Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8574 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0G3Itx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 04:49:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L6D00I4G4J08H10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Jul 2010 09:49:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6D001HR4IZCV@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Jul 2010 09:49:48 +0100 (BST)
Date: Fri, 30 Jul 2010 10:49:40 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v5 0/3] Multi-planar video format and buffer support for the
 V4L2 API
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Message-id: <1280479783-23945-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

After 9 months since the first proposal, lots of discussion and many changes, 
including an almost full redesign between versions 3 and 4, I present the
patches that add the fifth version of the multi-planar API for V4L2.

I am posting patches first for everyone to be able to take a look early and
would be grateful for some indication of your acceptance.

More documentation (DocBook) is on the way. Documentation in textual form can be
found below.


Changes since v4:
- struct v4l2_pix_format_mplane:
  * does not include a struct v4l2_pix_format anymore, replaced with concrete
    fields
  * new field: num_planes
- renamed fields in struct v4l2_plane (to prevent ambiguity):
  * mem_off -> mem_offset
  * data_off -> data_offset
- renamed field in struct v4l2_format (for consistency):
  * mp_pix -> pix_mp


Contents:
[PATCH v5 1/3] v4l: Add multi-planar API definitions to the V4L2 API
[PATCH v5 2/3] v4l: Add multi-planar ioctl handling code
[PATCH v5 3/3] v4l: Add compat functions for the multi-planar API


===============================================
I. Rationale
===============================================
Some embedded devices (including Samsung S3C/S5P SoC series) require physically
separate memory buffers for placing video components. For example, S5P SoC video
codec uses one buffer for Y and another for interleaved CbCr components. This
cannot be achieved with the current V4L2 API. One of the reasons is that
v4l2_buffer struct can only hold one pointer/offset to a video buffer.

As the proposal evolved, we found more uses for separate planes per buffer,
for non-embedded systems as well. Some examples include:
  - applications may receive (or choose to store) video data of one video
  buffer in separate memory buffers; such data would have to be temporarily
  copied together into one buffer before passing it to a V4L2 device;
  - applications or drivers may want to pass metadata related to a buffer and
  it may not be possible to place it in the same buffer together with video
  data;
Example features to be implemented in the future:
  - allowing video data to be stored in driver-provided memory (MMAP type) while
  metadata in application-provided buffers (USEPTR type) - useful for drivers
  that require coefficient matrices, that take or return header/metadata, etc.
  - allowing variable number of planes passed to each QBUF/DQBUF operations,
  differing between calls.


===============================================
II. Short introduction
===============================================

To establish a consistent nomenclature, for the remainder of this document:
 - "multi-planar" indicates a call/format used with multi-planar API,
   irrespective of the number of planes;
 - "1-plane format", "n-plane formats" indicate the number of planes in a format
   and have nothing to do with the API used; 1-plane formats can be used with
   the multi-planar API;


* The changes are fully backwards-compatible with the current V4L2 API.

* All multi-planar calls and types can be recognized by their utilization of new
buffer type defines (see below).

* Multi-planar API can be used as a superset of both APIs and can replace the
single-planar API; "old" formats can be used as 1-plane multi-planar formats.

* A format translation layer is also introduced, new drivers and applications
do not have to implement both API versions. A driver that only implements the
multi-planar version will still be able to transparently communicate with
applications that only use single-planar calls (but those applications will
only be able to use the driver's 1-plane formats). The other way around is also
possible - a driver that only implements the single-planar API can be used by
a multi-planar-API-only application fully.

* Applications can query for multi-planar capabilities by means of the standard
VIDIOC_QUERYCAP call.

* Affected ioctls are those that operate on either pix formats or buffers, which
are interpreted in a different way when one of the new buffer types is passed
in their corresponding fields:
 - VIDIOC_G_FMT, VIDIOC_S_FMT, VIDIOC_TRY_FMT, VIDIOC_ENUM_FMT;
 - VIDIOC_QBUF, VIDIOC_DQBUF, VIDIOC_QUERYBUF
 - VIDIOC_REQBUF (accepts new buffer types, behavior unchanged)

* Fourcc codes differ across plane counts, e.g. a 1-plane YCbCr fourcc is
different from that of an, otherwise identical, 2-plane YCbCr. On the other
hand, a 1-plane format uses the same fourcc code in both versions of the API.

* Applications do not have to support both APIs, it is enough to just use the
multi-planar version, as it will be transparently converted to single-planar
API for 1-plane-format-only drivers. Of course, it is not possible to set
a format with more than 1-plane for a single-planar-only driver, but
applications should not try this in the first place. They should use formats
returned from ENUM_FMT only and those will be 1-plane only.


===============================================
III. Multi-planar API format description/negotiation
===============================================


1. Maximum number of planes
----------------------------------

It has been agreed that the maximum number of planes per buffer will be 8:

+#define VIDEO_MAX_PLANES               8


2. Capability checks
----------------------------------

If a driver supports multi-planar API, it can set one (or both) of the new
capability flags:

+/* Is a video capture device that supports multiplanar formats */
+#define V4L2_CAP_VIDEO_CAPTURE_MPLANE  0x00001000
+/* Is a video output device that supports multiplanar formats */
+#define V4L2_CAP_VIDEO_OUTPUT_MPLANE   0x00002000

- any combination of those flags is valid;
- any combinations with V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_OUTPUT flags
  are also valid;
- the new flags indicate that a driver supports the multi-planar API, but it
  does NOT imply that it actually uses formats with more than 1 plane; it is
  perfectly possible and valid to use the new API for 1-plane formats only;
  using the new API for both 1-plane and n-plane formats makes the
  applications simpler, as they do not have to fall back to the old API in the
  former case.


3. Identifying multi-planar calls and structs:
----------------------------------

It is assumed (for now at least) that multi-planar API makes sense for pixel
formats only, so two new buffer types are added, for OUTPUT and CAPTURE:

 enum v4l2_buf_type {
        /* ... */
+       V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 17,
+       V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 18,
        /* ... */
 };


4. Describing multi-planar formats
----------------------------------

To describe multi-planar formats, the format struct has to be extended, as some
information has to be specified per plane:

 struct v4l2_format {
        enum v4l2_buf_type type;
        union {
                struct v4l2_pix_format          pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
+               struct v4l2_pix_format_mplane   pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
                struct v4l2_window              win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
                struct v4l2_vbi_format          vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
                struct v4l2_sliced_vbi_format   sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
                __u8    raw_data[200];                   /* user-defined */
        } fmt;
 };

For the new buffer types mp_pix member is chosen. For those buffer types,
struct v4l2_pix_format_mplane is used:

/**
 * struct v4l2_pix_format_mplane - multiplanar format definition
 * @width:              image width in pixels
 * @height:             image height in pixels
 * @pixelformat:        little endian four character code (fourcc)
 * @field:              field order (for interlaced video)
 * @colorspace:         supplemental to pixelformat
 * @plane_fmt:          per-plane information
 * @num_planes:         number of planes for this format and number of valid
 *                      elements in plane_fmt array
 */
struct v4l2_pix_format_mplane {
        __u32                           width;
        __u32                           height;
        __u32                           pixelformat;
        enum v4l2_field                 field;
        enum v4l2_colorspace            colorspace;

        struct v4l2_plane_pix_format    plane_fmt[VIDEO_MAX_PLANES];
        __u8                            num_planes;
        __u8                            reserved[11];
} __attribute__ ((packed));

New fourcc values have to be introduced for formats consisting of more than
1 plane.
Note: 1-plane formats retain their single-planar fourccs in multi-planar API, it
is the number of planes that rules this value, not the currently chosen API.


The per-plane format struct is as follows:

/**
 * struct v4l2_plane_pix_format - additional, per-plane format definition
 * @sizeimage:          maximum size in bytes required for data, for which
 *                      this plane will be used
 * @bytesperline:       distance in bytes between the leftmost pixels in two
 *                      adjacent lines
 */
struct v4l2_plane_pix_format {
        __u32           sizeimage;
        __u16           bytesperline;
        __u16           reserved[7];
} __attribute__ ((packed));


Fitting everything into v4l2_format's union (which is 200 bytes long):
v4l2_pix_format shouldn't be larger than 40 bytes.
8 * struct v4l2_plane_pix_format + 3 * 4 + 2 * enum + 12 * 1 = 8 * 20 + 40 = 200


5. Format enumeration
----------------------------------
struct v4l2_fmtdesc, used for format enumeration, does include the v4l2_buf_type
enum as well, so the new types are handled properly here as well.

Calls in the single-planar API should of course return 1-plane formats only.

For drivers supporting the new API, 1-plane formats should be returned for
multi-planar API calls types as well, for consistency. In other words, for
multi-planar API calls, the formats returned are a superset of those returned
when enumerating with the old buffer types.


6. Requesting buffers (buffer allocation)
----------------------------------
VIDIOC_REQBUFS includes v4l2_buf_type as well, so everything works as expected.
Drivers/allocators have to take into account plane requirements for the
currently selected format, such as per-plane alignment, etc.


7. Format conversion
----------------------------------
v4l2 core ioctl handling includes a simple conversion layer that allows
translation - when possible - between multi-planar and single-planar APIs,
transparently to drivers and applications.

The table below summarizes conversion behavior for cases when driver and
application use different API versions:

---------------------------------------------------------------
              | Application MP --> Driver SP --> Application MP
   G_FMT      |            always OK   |   always OK
   S_FMT      |            -EINVAL     |   always OK
 TRY_FMT      |            -EINVAL     |   always OK
---------------------------------------------------------------
              | Application SP --> Driver MP --> Application SP
   G_FMT      |            always OK   |   -EBUSY 
   S_FMT      |            always OK   |   -EBUSY and WARN()
 TRY_FMT      |            always OK   |   -EBUSY and WARN()

Legend:
- SP - single-planar API used (NOT format!)
- MP - multi-planar API used (NOT format!)
- always OK - conversion is always valid irrespective of number of planes
- -EINVAL - if an MP application tries to TRY or SET a format with more
            than 1 plane, EINVAL is returned from the conversion function
            (of course, 1-plane multi-planar formats work and are converted)
- -EBUSY - if an MP driver returns a more than 1-plane format to an SP
           application, the conversion layer returns EBUSY to the application;
           this is useful in cases when the driver is currently set to a more
           than 1-plane format, SP application would not be able to understand
           it)
- -EBUSY and WARN() - there is only one reason for which SET or TRY from an SP
           application would result in a driver returning a more than 1-plane
           format - when the driver adjusts a 1-plane format to a more than
           1-plane format. This should not happen and is a bug in driver, hence
           a WARN_ON(). Application receives EBUSY.


===============================================
IV. Multi-planar buffer and plane descriptors
===============================================

1. Adding plane info to v4l2_buffer
----------------------------------

 struct v4l2_buffer {
        /* ... */ 
        enum v4l2_buf_type      type;
        /* ... */ 
        union {
                __u32           offset;
                unsigned long   userptr;
+               struct v4l2_plane *planes;
        } m;
        __u32                   length;
        /* ... */
 };

Multi-planar buffers are also recognized using the new v4l2_buf_types.

For new buffer types, the "planes" member of the union is used. It should
contain a userspace pointer to an array of structs v4l2_plane. The size of this
array is to be passed in "length", as this field is not relevant for
multi-planar API buffers (plane lengths are specified per-plane in the
v4l2_plane struct instead).

Drivers can expect the planes field to contain a kernel pointer to the array,
it will be copied to kernelspace by ioctl handling code.


2. Plane description struct
----------------------------------

/**
 * struct v4l2_plane - plane info for multi-planar buffers
 * @bytesused:          number of bytes occupied by data in the plane (payload)
 * @mem_offset:         when memory in the associated struct v4l2_buffer is
 *                      V4L2_MEMORY_MMAP, equals the offset from the start of
 *                      the device memory for this plane (or is a "cookie" that
 *                      should be passed to mmap() called on the video node)
 * @userptr:            when memory is V4L2_MEMORY_USERPTR, a userspace pointer
 *                      pointing
 *                      to this plane
 * @length:             size of this plane (NOT the payload) in bytes
 * @data_offset:        offset in plane to the start of data/end of header,
 *                      if relevant
 *
 * Multi-planar buffers consist of one or more planes, e.g. an YCbCr buffer
 * with two planes can have one plane for Y, and another for interleaved CbCr
 * components. Each plane can reside in a separate memory buffer, or even in
 * a completely separate memory node (e.g. in embedded devices).
 */
struct v4l2_plane {
        __u32                   bytesused;
        __u32                   length;
        union {
                __u32           mem_offset;
                unsigned long   userptr;
        } m;
        __u32                   data_offset;
        __u32                   reserved[11];
};

If plane contents include not only data, but also a header, a driver may use
the data_offset member to indicate the offset in bytes to the start of the data.

Union m works in the same way as it does in the single-planar API for
v4l2_buffer. Which of the two to choose is decided by checking the memory field
in struct v4l2_buffer.


===============================================
V. Using ioctl()s and mmap()
===============================================

* Format calls (VIDIOC_S/TRY/G_FMT) are converted transparently across APIs
  by the ioctl handling code, where possible. Conversion from single-planar
  to multi-planar cannot fail, but the other way around is possible only for
  1-plane formats. 
  Possible errors in conversion are described below.

  To use multi-planar calls, pass a new buffer type and use the new pix_mp
  member of the struct.

* VIDIOC_S/TRY_FMT:
  - a single-planar call may fail (returning EBUSY) if a driver adjusts
    a 1-plane format to a more than 1-plane one. Note that this is considered
    a bug in the driver and will result in a kernel warning.
  - multi-planar call to a single-planar-only driver will result in EINVAL
    if a more than 1-plane format is requested

* VIDIOC_G_FMT:
  - a single-planar call may fail (returning EBUSY) if a driver has a more
    than 1-plane format currently set up; this is a normal situation and not
    a bug in the driver. This allows single-plane-only applications to use
    multi-planar drivers with their 1-plane formats.

* VIDIOC_ENUM_FMT:
  - for multi-planar API, should return a list of all formats supported by the
    driver (including 1-plane formats);
  - for single-planar API, will return 1-plane formats only;
  - an application does not have to enumerate formats in both APIs, as formats
    returned by multi-planar version are a superset of those returned by the
    single-planar version;
  - fourccs for the same pixel formats, differing only in number of planes,
    should differ; on the other hand, the same 1-plane format will have the same
    fourcc in both versions of the API;
  - format indexes (index field in struct v4l2_fmtdesc) may differ for the same
    formats between both APIs, so a 1-plane format may be returned with a
    different index across APIs.


* VIDIOC_REQBUFS:
Pass a new buffer type and count of video buffers (not planes) normally.
Expect the driver to return count (of buffers, not planes) as usual or EINVAL
if the multi-planar API is not supported.

The number of planes in a buffer is already known at the time of this call,
since it is specified by the currently chosen format.

* VIDIOC_QUERYBUFS:
Pass a v4l2_buffer struct as normal, setting a multi-planar buffer type and put
a pointer to an array of v4l2_plane structures under "planes". Place the size
of that array in the v4l2_buffer's "length" field. Expect the driver to fill
mem_offset fields in each v4l2_plane struct, analogically to offsets in
single-planar v4l2_buffers.

* VIDIOC_QBUF
As in the case of QUERYBUFS, pass the array of planes and its size in "length".
Fill all the fields required by non-multi-planar versions of this call, although
some of them in the planes' array members.

* VIDIOC_DQBUF
An array of planes does not have to be passed, in such case the "planes" pointer
has to be set to NULL and length should be set to 0.
If the array is passed, it will be filled with data, analogically to the
single-planar version of the API.

* mmap()
In the multi-planar API, not only every v4l2_buffer is a separate buffer in
memory, but every plane is a separate memory buffer as well. Therefore, every
plane has to be mapped separately. This requires num_planes * num_buffers calls
to mmap.

Note that the VIDIOC_QUERYBUF is called num_buffer times only, as each
v4l2_buffer passed to it contains offsets for all planes of a buffer.

Every mmap() call should be given the offsets provided in v4l2_plane structs.
There is no need for those calls to be in any particular order.

A v4l2_buffer changes state to mapped (V4L2_BUF_FLAG_MAPPED flag) only after all
of its planes have been mmapped successfully.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
