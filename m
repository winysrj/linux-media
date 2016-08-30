Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:34662 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756292AbcH3Q7w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 12:59:52 -0400
Received: by mail-yw0-f176.google.com with SMTP id z8so15121251ywa.1
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2016 09:59:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <512b52ab.02de420a.7040.7417SMTPIN_ADDED_BROKEN@mx.google.com>
References: <512b52ab.02de420a.7040.7417SMTPIN_ADDED_BROKEN@mx.google.com>
From: Rob Clark <robdclark@gmail.com>
Date: Tue, 30 Aug 2016 12:59:50 -0400
Message-ID: <CAF6AEGv7tz0AOz64fbA-exyFOBxW2RfWEq9m4fYVa5tZP8LUNw@mail.gmail.com>
Subject: Re: [Mesa-dev] [RFC] New dma_buf -> EGLImage EGL extension - Final
 spec published!
To: Tom Cooksey <tom.cooksey@arm.com>
Cc: "mesa-dev@lists.freedesktop.org" <mesa-dev@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tom,

hmm, I wonder if it was a bug/oversight for the YUV capabilities of
this extension to not depend on OES_EGL_image_external (which
unfortunately, doesn't seem to have a GL counterpart)?

I think this currently implies that you could sample from an imported
YUV eglimg using (for example) sampler2D in GL or GLES, which I think
was not the intention.

BR,
-R

On Mon, Feb 25, 2013 at 6:54 AM, Tom Cooksey <tom.cooksey@arm.com> wrote:
> Hi All,
>
> The final spec has had enum values assigned and been published on Khronos:
>
> http://www.khronos.org/registry/egl/extensions/EXT/EGL_EXT_image_dma_buf_import.txt
>
> Thanks to all who've provided input.
>
>
> Cheers,
>
> Tom
>
>
>
>> -----Original Message-----
>> From: mesa-dev-bounces+tom.cooksey=arm.com@lists.freedesktop.org [mailto:mesa-dev-
>> bounces+tom.cooksey=arm.com@lists.freedesktop.org] On Behalf Of Tom Cooksey
>> Sent: 04 October 2012 13:10
>> To: mesa-dev@lists.freedesktop.org; linaro-mm-sig@lists.linaro.org; dri-
>> devel@lists.freedesktop.org; linux-media@vger.kernel.org
>> Subject: [Mesa-dev] [RFC] New dma_buf -> EGLImage EGL extension - New draft!
>>
>> Hi All,
>>
>> After receiving a fair bit of feedback (thanks!), I've updated the
>> EGL_EXT_image_dma_buf_import spec
>> and expanded it to resolve a number of the issues. Please find the latest draft below and let
>> me
>> know any additional feedback you might have, either on the lists or by private e-mail - I
>> don't mind
>> which.
>>
>> I think the only remaining issue now is if we need a mechanism whereby an application can
>> query
>> which drm_fourcc.h formats EGL supports or if just failing with EGL_BAD_MATCH when the
>> application
>> has use one EGL doesn't support is sufficient. Any thoughts?
>>
>>
>> Cheers,
>>
>> Tom
>>
>>
>> --------------------8<--------------------
>>
>>
>> Name
>>
>>     EXT_image_dma_buf_import
>>
>> Name Strings
>>
>>     EGL_EXT_image_dma_buf_import
>>
>> Contributors
>>
>>     Jesse Barker
>>     Rob Clark
>>     Tom Cooksey
>>
>> Contacts
>>
>>     Jesse Barker (jesse 'dot' barker 'at' linaro 'dot' org)
>>     Tom Cooksey (tom 'dot' cooksey 'at' arm 'dot' com)
>>
>> Status
>>
>>     DRAFT
>>
>> Version
>>
>>     Version 4, October 04, 2012
>>
>> Number
>>
>>     EGL Extension ???
>>
>> Dependencies
>>
>>     EGL 1.2 is required.
>>
>>     EGL_KHR_image_base is required.
>>
>>     The EGL implementation must be running on a Linux kernel supporting the
>>     dma_buf buffer sharing mechanism.
>>
>>     This extension is written against the wording of the EGL 1.2 Specification.
>>
>> Overview
>>
>>     This extension allows creating an EGLImage from a Linux dma_buf file
>>     descriptor or multiple file descriptors in the case of multi-plane YUV
>>     images.
>>
>> New Types
>>
>>     None
>>
>> New Procedures and Functions
>>
>>     None
>>
>> New Tokens
>>
>>     Accepted by the <target> parameter of eglCreateImageKHR:
>>
>>         EGL_LINUX_DMA_BUF_EXT
>>
>>     Accepted as an attribute in the <attrib_list> parameter of
>>     eglCreateImageKHR:
>>
>>         EGL_LINUX_DRM_FOURCC_EXT
>>         EGL_DMA_BUF_PLANE0_FD_EXT
>>         EGL_DMA_BUF_PLANE0_OFFSET_EXT
>>         EGL_DMA_BUF_PLANE0_PITCH_EXT
>>         EGL_DMA_BUF_PLANE1_FD_EXT
>>         EGL_DMA_BUF_PLANE1_OFFSET_EXT
>>         EGL_DMA_BUF_PLANE1_PITCH_EXT
>>         EGL_DMA_BUF_PLANE2_FD_EXT
>>         EGL_DMA_BUF_PLANE2_OFFSET_EXT
>>         EGL_DMA_BUF_PLANE2_PITCH_EXT
>>         EGL_YUV_COLOR_SPACE_HINT_EXT
>>         EGL_SAMPLE_RANGE_HINT_EXT
>>         EGL_YUV_CHROMA_HORIZONTAL_SITING_HINT_EXT
>>         EGL_YUV_CHROMA_VERTICAL_SITING_HINT_EXT
>>
>>     Accepted as the value for the EGL_YUV_COLOR_SPACE_HINT_EXT attribute:
>>
>>         EGL_ITU_REC601_EXT
>>         EGL_ITU_REC709_EXT
>>         EGL_ITU_REC2020_EXT
>>
>>     Accepted as the value for the EGL_SAMPLE_RANGE_HINT_EXT attribute:
>>
>>         EGL_YUV_FULL_RANGE_EXT
>>         EGL_YUV_NARROW_RANGE_EXT
>>
>>     Accepted as the value for the EGL_YUV_CHROMA_HORIZONTAL_SITING_HINT_EXT &
>>     EGL_YUV_CHROMA_VERTICAL_SITING_HINT_EXT attributes:
>>
>>         EGL_YUV_CHROMA_SITING_0_EXT
>>         EGL_YUV_CHROMA_SITING_0_5_EXT
>>
>>
>> Additions to Chapter 2 of the EGL 1.2 Specification (EGL Operation)
>>
>>     Add to section 2.5.1 "EGLImage Specification" (as defined by the
>>     EGL_KHR_image_base specification), in the description of
>>     eglCreateImageKHR:
>>
>>    "Values accepted for <target> are listed in Table aaa, below.
>>
>>       +-------------------------+--------------------------------------------+
>>       |  <target>               |  Notes                                     |
>>       +-------------------------+--------------------------------------------+
>>       |  EGL_LINUX_DMA_BUF_EXT  |   Used for EGLImages imported from Linux   |
>>       |                         |   dma_buf file descriptors                 |
>>       +-------------------------+--------------------------------------------+
>>        Table aaa.  Legal values for eglCreateImageKHR <target> parameter
>>
>>     ...
>>
>>     If <target> is EGL_LINUX_DMA_BUF_EXT, <dpy> must be a valid display, <ctx>
>>     must be EGL_NO_CONTEXT, and <buffer> must be NULL, cast into the type
>>     EGLClientBuffer. The details of the image is specified by the attributes
>>     passed into eglCreateImageKHR. Required attributes and their values are as
>>     follows:
>>
>>         * EGL_WIDTH & EGL_HEIGHT: The logical dimensions of the buffer in pixels
>>
>>         * EGL_LINUX_DRM_FOURCC_EXT: The pixel format of the buffer, as specified
>>           by drm_fourcc.h and used as the pixel_format parameter of the
>>           drm_mode_fb_cmd2 ioctl.
>>
>>         * EGL_DMA_BUF_PLANE0_FD_EXT: The dma_buf file descriptor of plane 0 of
>>           the image.
>>
>>         * EGL_DMA_BUF_PLANE0_OFFSET_EXT: The offset from the start of the
>>           dma_buf of the first sample in plane 0, in bytes.
>>
>>         * EGL_DMA_BUF_PLANE0_PITCH_EXT: The number of bytes between the start of
>>           subsequent rows of samples in plane 0. May have special meaning for
>>           non-linear formats.
>>
>>     For images in an RGB color-space or those using a single-plane YUV format,
>>     only the first plane's file descriptor, offset & pitch should be specified.
>>     For semi-planar YUV formats, the chroma samples are stored in plane 1 and
>>     for fully planar formats, U-samples are stored in plane 1 and V-samples are
>>     stored in plane 2. Planes 1 & 2 are specified by the following attributes,
>>     which have the same meanings as defined above for plane 0:
>>
>>         * EGL_DMA_BUF_PLANE1_FD_EXT
>>         * EGL_DMA_BUF_PLANE1_OFFSET_EXT
>>         * EGL_DMA_BUF_PLANE1_PITCH_EXT
>>         * EGL_DMA_BUF_PLANE2_FD_EXT
>>         * EGL_DMA_BUF_PLANE2_OFFSET_EXT
>>         * EGL_DMA_BUF_PLANE2_PITCH_EXT
>>
>>     In addition to the above required attributes, the application may also
>>     provide hints as to how the data should be interpreted by the GL. If any of
>>     these hints are not specified, the GL will guess based on the pixel format
>>     passed as the EGL_LINUX_DRM_FOURCC_EXT attribute or may fall-back to some
>>     default value. Not all GLs will be able to support all combinations of
>>     these hints and are free to use whatever settings they choose to achieve
>>     the closest possible match.
>>
>>         * EGL_YUV_COLOR_SPACE_HINT_EXT: The color-space the data is in. Only
>>           relevant for images in a YUV format, ignored when specified for an
>>           image in an RGB format. Accepted values are:
>>           EGL_ITU_REC601_EXT, EGL_ITU_REC709_EXT & EGL_ITU_REC2020_EXT.
>>
>>         * EGL_YUV_CHROMA_HORIZONTAL_SITING_HINT_EXT &
>>           EGL_YUV_CHROMA_VERTICAL_SITING_HINT_EXT: Where chroma samples are
>>           sited relative to luma samples when the image is in a sub-sampled
>>           format. When the image is not using chroma sub-sampling, the luma and
>>           chroma samples are assumed to be co-sited. Siting is split into the
>>           vertical and horizontal and is in a fixed range. A siting of zero
>>           means the first luma sample is taken from the same position in that
>>           dimension as the chroma sample. This is best illustrated in the
>>           diagram below:
>>
>>                  (0.5, 0.5)        (0.0, 0.5)        (0.0, 0.0)
>>                 +   +   +   +     +   +   +   +     *   +   *   +
>>                   x       x       x       x
>>                 +   +   +   +     +   +   +   +     +   +   +   +
>>
>>                 +   +   +   +     +   +   +   +     *   +   *   +
>>                   x       x       x       x
>>                 +   +   +   +     +   +   +   +     +   +   +   +
>>
>>             Luma samples (+), Chroma samples (x) Chrome & Luma samples (*)
>>
>>           Note this attribute is ignored for RGB images and non sub-sampled
>>           YUV images. Accepted values are: EGL_YUV_CHROMA_SITING_0_EXT (0.0)
>>           & EGL_YUV_CHROMA_SITING_0_5_EXT (0.5)
>>
>>         * EGL_SAMPLE_RANGE_HINT_EXT: The numerical range of samples. Only
>>           relevant for images in a YUV format, ignored when specified for
>>           images in an RGB format. Accepted values are: EGL_YUV_FULL_RANGE_EXT
>>           (0-256) & EGL_YUV_NARROW_RANGE_EXT (16-235).
>>
>>
>>     If eglCreateImageKHR is successful for a EGL_LINUX_DMA_BUF_EXT target, the
>>     EGL takes ownership of the file descriptor and is responsible for closing
>>     it, which it may do at any time while the EGLDisplay is initialized."
>>
>>
>>     Add to the list of error conditions for eglCreateImageKHR:
>>
>>       "* If <target> is EGL_LINUX_DMA_BUF_EXT and <buffer> is not NULL, the
>>          error EGL_BAD_PARAMETER is generated.
>>
>>        * If <target> is EGL_LINUX_DMA_BUF_EXT, and the list of attributes is
>>          incomplete, EGL_BAD_PARAMETER is generated.
>>
>>        * If <target> is EGL_LINUX_DMA_BUF_EXT, and the EGL_LINUX_DRM_FOURCC_EXT
>>          attribute is set to a format not supported by the EGL, EGL_BAD_MATCH
>>          is generated.
>>
>>        * If <target> is EGL_LINUX_DMA_BUF_EXT, and the EGL_LINUX_DRM_FOURCC_EXT
>>          attribute indicates a single-plane format, EGL_BAD_ATTRIBUTE is
>>          generated if any of the EGL_DMA_BUF_PLANE1_* or EGL_DMA_BUF_PLANE2_*
>>          attributes are specified.
>>
>>        * If <target> is EGL_LINUX_DMA_BUF_EXT and the value specified for
>>          EGL_YUV_COLOR_SPACE_HINT_EXT is not EGL_ITU_REC601_EXT,
>>          EGL_ITU_REC709_EXT or EGL_ITU_REC2020_EXT, EGL_BAD_ATTRIBUTE is
>>          generated.
>>
>>        * If <target> is EGL_LINUX_DMA_BUF_EXT and the value specified for
>>          EGL_SAMPLE_RANGE_HINT_EXT is not EGL_YUV_FULL_RANGE_EXT or
>>          EGL_YUV_NARROW_RANGE_EXT, EGL_BAD_ATTRIBUTE is generated.
>>
>>        * If <target> is EGL_LINUX_DMA_BUF_EXT and the value specified for
>>          EGL_YUV_CHROMA_HORIZONTAL_SITING_HINT_EXT or
>>          EGL_YUV_CHROMA_VERTICAL_SITING_HINT_EXT is not
>>          EGL_YUV_CHROMA_SITING_0_EXT or EGL_YUV_CHROMA_SITING_0_5_EXT,
>>          EGL_BAD_ATTRIBUTE is generated.
>>
>>        * If <target> is EGL_LINUX_DMA_BUF_EXT and one or more of the values
>>          specified for a plane's pitch or offset isn't supported by EGL,
>>          EGL_BAD_ACCESS is generated.
>>
>>        * If <target> is EGL_LINUX_DMA_BUF_EXT and eglCreateImageKHR fails,
>>          EGL does not retain ownership of the file descriptor and it is the
>>          responsibility of the application to close it."
>>
>>
>> Issues
>>
>>     1. Should this be a KHR or EXT extension?
>>
>>     ANSWER: EXT. Khronos EGL working group not keen on this extension as it is
>>     seen as contradicting the EGLStream direction the specification is going in.
>>     The working group recommends creating additional specs to allow an EGLStream
>>     producer/consumer connected to v4l2/DRM or any other Linux interface.
>>
>>     2. Should this be a generic any platform extension, or a Linux-only
>>     extension which explicitly states the handles are dma_buf fds?
>>
>>     ANSWER: There's currently no intention to port this extension to any OS not
>>     based on the Linux kernel. Consequently, this spec can be explicitly written
>>     against Linux and the dma_buf API.
>>
>>     3. Does ownership of the file descriptor pass to the EGL library?
>>
>>     ANSWER: If eglCreateImageKHR is successful, EGL assumes ownership of the
>>     file descriptors and is responsible for closing them.
>>
>>     4. How are the different YUV color spaces handled (BT.709/BT.601)?
>>
>>     ANSWER: The pixel formats defined in drm_fourcc.h only specify how the data
>>     is laid out in memory. It does not define how that data should be
>>     interpreted. Added a new EGL_YUV_COLOR_SPACE_HINT_EXT attribute to allow the
>>     application to specify which color space the data is in to allow the GL to
>>     choose an appropriate set of co-efficients if it needs to convert that data
>>     to RGB for example.
>>
>>     5. What chroma-siting is used for sub-sampled YUV formats?
>>
>>     ANSWER: The chroma siting is not specified by either the v4l2 or DRM APIs.
>>     This is similar to the color-space issue (4) in that the chroma siting
>>     doesn't affect how the data is stored in memory. However, the GL will need
>>     to know the siting in order to filter the image correctly. While the visual
>>     impact of getting the siting wrong is minor, provision should be made to
>>     allow an application to specify the siting if desired. Added additional
>>     EGL_YUV_CHROMA_HORIZONTAL_SITING_HINT_EXT &
>>     EGL_YUV_CHROMA_VERTICAL_SITING_HINT_EXT attributes to allow the siting to
>>     be specified using a set of pre-defined values (0 or 0.5).
>>
>>     6. How can an application query which formats the EGL implementation
>>     supports?
>>
>>     PROPOSAL: Don't provide a query mechanism but instead add an error condition
>>     that EGL_BAD_MATCH is raised if the EGL implementation doesn't support that
>>     particular format.
>>
>>     7. Which image formats should be supported and how is format specified?
>>
>>     Seem to be two options 1) specify a new enum in this specification and
>>     enumerate all possible formats. 2) Use an existing enum already in Linux,
>>     either v4l2_mbus_pixelcode and/or those formats listed in drm_fourcc.h?
>>
>>     ANSWER: Go for option 2) and just use values defined in drm_fourcc.h.
>>
>>     8. How can AYUV images be handled?
>>
>>     ANSWER: At least on fourcc.org and in drm_fourcc.h, there only seems to be
>>     a single AYUV format and that is a packed format, so everything, including
>>     the alpha component would be in the first plane.
>>
>>     9. How can you import interlaced images?
>>
>>     ANSWER: Interlaced frames are usually stored with the top & bottom fields
>>     interleaved in a single buffer. As the fields would need to be displayed as
>>     at different times, the application would create two EGLImages from the same
>>     buffer, one for the top field and another for the bottom. Both EGLImages
>>     would set the pitch to 2x the buffer width and the second EGLImage would use
>>     a suitable offset to indicate it started on the second line of the buffer.
>>     This should work regardless of whether the data is packed in a single plane,
>>     semi-planar or multi-planar.
>>
>>     If each interlaced field is stored in a separate buffer then it should be
>>     trivial to create two EGLImages, one for each field's buffer.
>>
>>     10. How are semi-planar/planar formats handled that have a different
>>     width/height for Y' and CbCr such as YUV420?
>>
>>     ANSWER: The spec says EGL_WIDTH & EGL_HEIGHT specify the *logical* width and
>>     height of the buffer in pixels. For pixel formats with sub-sampled Chroma
>>     values, it should be trivial for the EGL implementation to calculate the
>>     width/height of the Chroma sample buffers using the logical width & height
>>     and by inspecting the pixel format passed as the EGL_LINUX_DRM_FOURCC_EXT
>>     attribute. I.e. If the pixel format says it's YUV420, the Chroma buffer's
>>     width = EGL_WIDTH/2 & height =EGL_HEIGHT/2.
>>
>>     11. How are Bayer formats handled?
>>
>>     ANSWER: As of Linux 2.6.34, drm_fourcc.h does not include any Bayer formats.
>>     However, future kernel versions may add such formats in which case they
>>     would be handled in the same way as any other format.
>>
>>     12. Should the spec support buffers which have samples in a "narrow range"?
>>
>>     Content sampled from older analogue sources typically don't use the full
>>     (0-256) range of the data type storing the sample and instead use a narrow
>>     (16-235) range to allow some headroom & toeroom in the signals to avoid
>>     clipping signals which overshoot slightly during processing. This is
>>     sometimes known as signals using "studio swing".
>>
>>     ANSWER: Add a new attribute to define if the samples use a narrow 16-235
>>     range or the full 0-256 range.
>>
>>     13. Specifying the color space and range seems cumbersome, why not just
>>     allow the application to specify the full YUV->RGB color conversion matrix?
>>
>>     ANSWER: Some hardware may not be able to use an arbitrary conversion matrix
>>     and needs to select an appropriate pre-defined matrix based on the color
>>     space and the sample range.
>>
>>     14. How do you handle EGL implementations which have restrictions on pitch
>>     and/or offset?
>>
>>     ANSWER: Buffers being imported using dma_buf pretty much have to be
>>     allocated by a kernel-space driver. As such, it is expected that a system
>>     integrator would make sure all devices which allocate buffers suitable for
>>     exporting make sure they use a pitch supported by all possible importers.
>>     However, it is still possible eglCreateImageKHR can fail due to an
>>     unsupported pitch. Added a new error to the list indicating this.
>>
>>     15. Should this specification also describe how to export an existing
>>     EGLImage as a dma_buf file descriptor?
>>
>>     ANSWER: No. Importing and exporting buffers are two separate operations and
>>     importing an existing dma_buf fd into an EGLImage is useful functionality in
>>     itself. Agree that exporting an EGLImage as a dma_buf fd is useful, E.g. it
>>     could be used by an OpenMAX IL implementation's OMX_UseEGLImage function to
>>     give access to the buffer backing an EGLImage to video hardware. However,
>>     exporting can be split into a separate extension specification.
>>
>>
>> Revision History
>>
>> #4 (Tom Cooksey, October 04, 2012)
>>    - Fixed issue numbering!
>>    - Added issues 8 - 15.
>>    - Promoted proposal for Issue 3 to be the answer.
>>    - Added an additional attribute to allow an application to specify the color
>>      space as a hint which should address issue 4.
>>    - Added an additional attribute to allow an application to specify the chroma
>>      siting as a hint which should address issue 5.
>>    - Added an additional attribute to allow an application to specify the sample
>>      range as a hint which should address the new issue 12.
>>    - Added language to end of error section clarifying who owns the fd passed
>>      to eglCreateImageKHR if an error is generated.
>>
>> #3 (Tom Cooksey, August 16, 2012)
>>    - Changed name from EGL_EXT_image_external and re-written language to
>>      explicitly state this for use with Linux & dma_buf.
>>    - Added a list of issues, including some still open ones.
>>
>> #2 (Jesse Barker, May 30, 2012)
>>    - Revision to split eglCreateImageKHR functionality from export
>>      Functionality.
>>    - Update definition of EGLNativeBufferType to be a struct containing a list
>>      of handles to support multi-buffer/multi-planar formats.
>>
>> #1 (Jesse Barker, March 20, 2012)
>>    - Initial draft.
>>
>>
>>
>>
>> _______________________________________________
>> mesa-dev mailing list
>> mesa-dev@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/mesa-dev
>
>
>
>
> _______________________________________________
> mesa-dev mailing list
> mesa-dev@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/mesa-dev
