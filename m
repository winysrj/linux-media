Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38256 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731501AbeGMU2x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 16:28:53 -0400
Received: from 177.157.125.74.dynamic.adsl.gvt.net.br ([177.157.125.74] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fe4Qm-0007ak-Vu
        for linux-media@vger.kernel.org; Fri, 13 Jul 2018 20:12:45 +0000
Date: Fri, 13 Jul 2018 17:12:42 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [ANN] Report for Linux Media Complex Camera Workshop
Message-ID: <20180713171242.64aedfa7@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For an HTML version, please see:
	https://linuxtv.org/news.php?entry=3D2018-07-13.mchehab

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Linux Complex Cameras Workshop - 2018
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Attendees
---------

    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
    Sakari Ailus
    Jian Xu Zheng
    Jerry Hu
    Tomasz Figa
    Alexandre Courbot
    Laurent Pinchart
    Mauro Carvalho Chehab
    Kieran Bingham
    Niklas S=C3=B6derlund
    Nicolas Dufresne
    Paul Elder
    Jacopo Mondi
    Ricky Liang
    Daniel Wu
    Hans Verkuil
    Javier Martinez Canillas
    Pavel Machek
    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D


Slides and pictures
-------------------

   - https://drive.google.com/drive/folders/1WdmAHMRpZZDDwXiCfNrUQnhDc3VFnD=
CE?usp=3Dsharing

Group Photo
-----------

   - https://photos.app.goo.gl/fmrZDvcm3jPrqsPJ9


Introduction
------------

New laptops are arriving without webcam support in the Linux Kernel
due to 'complex camera' devices.

- Dell Latitude 5285 is the first known to have this issue:

    ``Re: Webcams not recognized on a Dell Latitude 5285 laptop``:

	https://www.spinics.net/lists/linux-media/msg131388.html

    ``[RESEND GIT PULL for 4.16] Intel IPU3 CIO2 CSI-2 receiver driver``:

	https://www.mail-archive.com/linux-media@vger.kernel.org/msg122619.html


1. libv4l review
----------------

Mauro presented a short review of the libv4l stack.

- Contains libv4lconvert, a conversion and decompression library, but only
  accessible through device nodes abstraction;

- Emulates the old V4L1 API, this is considered ready for retirement;

- Finally, contains a general emulation of V4L2, which abstracts libv4lconv=
ert,
  modified formats are flag emulated;

- Main issue, no more maintainers, causes issue if features get added
  in V4L2 API without equivalent emulation (notably CREATE_BUFS).

2. Intel IPU3
-------------

- Graphs and pipelines are ISP-specific concepts. They are passed to the
  firmware as configuration data so that the ISP gets configured to operate
  as the given pipeline. This isn't exposed through the MC API.

- Side Note: IPU3 have some similitude with Mali C71 ISP
  https://developer.arm.com/products/graphics-and-multimedia/mali-camera
  This ISP can work pixel, lines, frame bases, using M2M manner, but
  that's all there is public about it for now.

IPU3 parameter documentation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  https://www.mail-archive.com/linux-media@vger.kernel.org/msg132827.html

Glossary
^^^^^^^^

    :P2P: Public to Private

    :CPF Data: tuning data

    :IQStudio: tuning tool


Notes
^^^^^

- ChromeOS camera HAL implementation is different from Android but the API
  is the same

Slicing
^^^^^^^

    - The image may need to be processed by the ISP in several iterations
    - The line buffer length is a physical property of an ISP; images wider
      than that require slicing
    - Slicing may be handled in ISP specific code but not in application AP=
Is

Planning
^^^^^^^^

- Starting point for supporting regular V4L2 programs for complex cameras
  should be based on LD_PRELOAD as with libv4l, but not the current libv4l
  implementation.

- 3A algorithms generally take ISP statistics as input and produce sensor
  configuration (exposure time, gain) and ISP parameters as output;

- Pure software implementation (without use of ISP statistics, without
  producing ISP parameters) may be used for development purposes but for
  performance reasons such a solution is not usable for video streaming

    - Therefore any real-world solution needs to make use of an ISP

- The target is to define APIs

    - Towards 3A algorithms, which could be proprietary
    - Towards applications

- Some hardware has SoC cameras (smart sensors) that have built-in ISP
  controlled through a high-level interface on the sensor. Such ISPs need
  no software control such as ISPs present on SoCs do. The designed APIs
  should not assume either kind of a system (SoC camera or raw sensor + ISP=
).

- GPUs could be used for processing images as well.

- Optimal image processing pipeline is somewhat hardware specific.

- Fixed function and programmable hardware exists:

    - Even programmable ISPs are much less generic than GPUs today

    - No industry-wide APIs for ISPs

- Fixed function pipeline may be assumed:

    - This serves the widest set of ISPs

    - If a programmable pipeline is needed it can be considered later
      on when there could be tangible benefit from it


3. Requirements
---------------

- Support for libv4l-based apps

- Support for closed source binary blobs (LD_PRELOAD)

- Support for closed source 3A algorithms with an external API

- Pipeline settings - configuration file + generic hander + possibility
  for vendor-specific code

- Provide the same API for both MC-based and devnode-based hardware

- Support for different profiles

- Sandbox support for closed source binary blobs

- Application needs: Frames and control

- Support Android HAL

- Use Android HAL as a source of requirements

- Port Andorid HAL and xawtv3 to use it

- Further specify the API to cover parts not specified in Android HAL v3 AP=
I:
     - include profiles (viewfinder, still capture, etc.).

Android camera HAL v3 painpoints
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    The API is underspecified. It offers multiple ways to achieve the same
    result (for `m` streams, queuing `n` requests with `m` buffers each, or
    `n*m` requests with 1 buffer each). In practice only a subset of those
    options work for a given HAL implementation. Applications need to comply
    with those unwritten limitations, and HAL implementations in practice g=
et
    tested with CTS and a few applications, and thus implement a subset
    of the options only.

    The API doesn't carry stream usage information (viewfinder, video
    capture, still image capture, ...). That information is translated
    to requests, and the HAL implementation often uses heuristics to
    recover the usage information from the requests as the ISP often
    hardcodes (in hardware or firmware) use cases.

    A request requires frames with a specific set of parameters to be
    captured to specific buffers. This is very difficult to achieve due
    to real time requirements in pipeline configuration. The HAL has to
    enqueue buffers at the exact right time, and when the time window
    to do so is missed, the needed image is captured to the wrong buffer.
    A memcpy() is then often the only option to recover. It would be
    much easier if a request instead required capturing the frame
    to any buffer from a given pool.


- Supporting devices with multiple inputs

     - Multiple inputs would be exposed as separate devices in the
       enumeration stage.


- If we want to support TV inputs and/or HDMI inputs (recommanded IMHO!),
  then we need:

    - setting/querying TV standards (*_STD ioctls)

    - setting/querying video timings (*_DV_TIMINGS ioctls)

    - hotplugging (events when the video signal goes away or
      a new stable video signal is detected)

For testing in upstream one could use:
    - Asus Tinkerboard (RK3288)

      - https://www.asus.com/Single-Board-Computer/Tinker-Board/specificati=
ons/

    - i.MX6 (freescale) boards are also widely available:

      - https://www.engicam.com/vis-prod/101145 with ov5640 included

      - https://www.wandboard.org/ is also i.MX6, and easy to get hold of

      - https://boundarydevices.com/ sells lots of freescale devboards

    - 96 Board ROCK960:

      - https://www.96boards.org/product/rock960/ + https://www.96boards.or=
g/product/d3camera/

Configuration files used for IPU3 on Chrome OS:

- https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/ma=
ster/baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/files/camera3=
_profiles.xml
- https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/ma=
ster/baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/files/gcss/

Tuning data used on Chromebook with IPU3, with license:

- https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/ma=
ster/baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/files/tuning_=
files/

4. Laurent's proposal
---------------------

(Attach the diagram here):

3 types of APIs could be created:

   1. APIs between App and Camera stack

   2. APIs between Camera stack and pipeline handler

   3. APIs between Camera stack and 3A algos

5. Intel proposal
-----------------

3A is more than 3A, there's a whole set of imaging algorithms that need
a userspace control loop (digital video stabilization, tone mapping, ...)

Imaging algorithms are customized for a device through three sets of data:

 - The algorithm implementation itself is ISP-specific

 - A tuning data file provides information related to a particular
   sensor model (and VCM model) to fine-tune the algorithms

 - Per-unit calibration data (usually stored in NVM) provide further
   information to fine-tune the algorithms to take instance-specific
   characteristics into account.

6. Pipewire introduction
------------------------

- Started as a Dbus based solution to share videos (Pinos) + Audio =3D Pipe=
Wire

- Pipeline based - bridge between application and devices

- plugins to bind devices together (nodes) and a daemon to manage them

- library: manages creation and linking of objects; groups them in graphs
  (1 graph per pipewire instance)
- nodes are shareabled between instances (inter-process connections)

- memfd is used for buffer allocation/sharing: no copy/allocation

- event based processing (eg. buffer dequeue event on v4l2 source
  triggers processing in a connected object)

- graph topology is managed by pipewire clients that instantiate
  and link objects

- format and buffer negotiation happens at link creation time

- lossy: if clients do not consume buffers fast enough, data are
  overwritten by the source

- buffer are re-sizeable at runtime provided some constraint
  initially specified are respected

- v4l2-ctrls are modeled as configuration parameters between client
  and source, and applied at each frame capture (no support for
  multiple clients acting on parameters of the same source)

- explicit fences support: to be implemented, no arbitration issues

- image metadata can be piggy-backed on video buffers and consumed by clien=
ts

- only mmap support at the moment; no v4l2 emulation layer

- No DVB support planned - it should work in a similar way to the V4L2 sour=
ce

- No plans for now for explicit fences

Next steps
----------

- Specify the application-level API (based on Android HALv3 + differences),
  e. g considering the HALv3 pinpoints:

  - The API is underspecified. It offers multiple ways to achieve the same
    result (for `m` streams, queuing `n` requests with `m` buffers each, or
    `n*m` requests with 1 buffer each). In practice only a subset of those
    options work for a given HAL implementation. Applications need to comply
    with those unwritten limitations, and HAL implementations in practice
    get tested with CTS and a few applications, and thus implement a subset
    of the options only.

  - The API doesn't carry stream usage information (viewfinder, video captu=
re,
    still image capture, ...). That information is translated to requests,
    and the HAL implementation often uses heuristics to recover the usage
    information from the requests as the ISP often hardcodes (in hardware
    or firmware) use cases.

    - Add API to query platform for available usages and allow applications
      to configure streams based on usages, which can be further overriden
      from details using optional parameters.

   - A request requires frames with a specific set of parameters to be
     captured to specific buffers. This is very difficult to achieve due
     to real time requirements in pipeline configuration. The HAL has to
     enqueue buffers at the exact right time, and when the time window
     to do so is missed, the needed image is captured to the wrong buffer.
     A memcpy() is then often the only option to recover.
     It would be much easier if a request instead required capturing the
     frame to any buffer from a given pool.

     - Tomasz noticed that he's not really sure this is true, at least
       not for all capability levels. So, this need to be checked.

  Android HALv3 API requires buffers for streams explicitly assigned in
  capture requests. Where does the application take them from?

    - Just add API to allocate buffers.

- Try to unify Chrome OS IPU3 and RKISP1 HALs back and make it support
  simple USB webcams too

- Create an Android HALv3 (pure) compatibility layer on top of our API

- Create a V4L2 Webcam compatibility layer on top of our API,

Question:
  If someone wants to replace HW ISP with CUDA or OpenSL accelerator,
  anything to keep in mind ?

  - Good to keep in mind, but short term, V4L2 drivers for ISP
    is more likely (IPU3/4, OMAP, ...)
