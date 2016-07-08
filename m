Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46316 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbcGHVFV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 17:05:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 1/4] [media] doc-rst: linux_tv CEC part, DocBook to reST migration
Date: Fri,  8 Jul 2016 18:05:08 -0300
Message-Id: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

This is the reST migration of media's CEC part.  The migration is based
on media_tree's cec branch:

 https://git.linuxtv.org/media_tree.git

 c7169ad * cec media_tree/cec [media] DocBook/media: add CEC documentation

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/media_uapi.rst                 |  13 +-
 Documentation/media/uapi/cec/cec-api.rst           |  94 +++++
 Documentation/media/uapi/cec/cec-func-close.rst    |  57 +++
 Documentation/media/uapi/cec/cec-func-ioctl.rst    |  77 ++++
 Documentation/media/uapi/cec/cec-func-open.rst     |  88 +++++
 Documentation/media/uapi/cec/cec-func-poll.rst     |  74 ++++
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         | 174 +++++++++
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    | 427 +++++++++++++++++++++
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    |  78 ++++
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   | 237 ++++++++++++
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    | 311 +++++++++++++++
 Documentation/media/uapi/cec/cec-ioc-receive.rst   | 329 ++++++++++++++++
 Documentation/media/uapi/v4l/biblio.rst            |  10 +
 13 files changed, 1964 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/media/uapi/cec/cec-api.rst
 create mode 100644 Documentation/media/uapi/cec/cec-func-close.rst
 create mode 100644 Documentation/media/uapi/cec/cec-func-ioctl.rst
 create mode 100644 Documentation/media/uapi/cec/cec-func-open.rst
 create mode 100644 Documentation/media/uapi/cec/cec-func-poll.rst
 create mode 100644 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
 create mode 100644 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
 create mode 100644 Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
 create mode 100644 Documentation/media/uapi/cec/cec-ioc-dqevent.rst
 create mode 100644 Documentation/media/uapi/cec/cec-ioc-g-mode.rst
 create mode 100644 Documentation/media/uapi/cec/cec-ioc-receive.rst

diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index 8211cc963b56..49f5cb5ed825 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -37,21 +37,23 @@ A typical media device hardware is shown at
     Typical Media Device
 
 The media infrastructure API was designed to control such devices. It is
-divided into four parts.
+divided into five parts.
 
-The :Ref:`first part <v4l2spec>` covers radio, video capture and output,
+The :ref:`first part <v4l2spec>` covers radio, video capture and output,
 cameras, analog TV devices and codecs.
 
-The :Ref:`second part <dvbapi>` covers the API used for digital TV and
+The :ref:`second part <dvbapi>` covers the API used for digital TV and
 Internet reception via one of the several digital tv standards. While it
 is called as DVB API, in fact it covers several different video
 standards including DVB-T/T2, DVB-S/S2, DVB-C, ATSC, ISDB-T, ISDB-S,
 DTMB, etc. The complete list of supported standards can be found at
 :ref:`fe-delivery-system-t`.
 
-The :Ref:`third part <remote_controllers>` covers the Remote Controller API.
+The :ref:`third part <remote_controllers>` covers the Remote Controller API.
 
-The :Ref:`fourth part <media_controller>` covers the Media Controller API.
+The :ref:`fourth part <media_controller>` covers the Media Controller API.
+
+The :ref:`fifth part <cec>` covers the CEC (Consumer Electronics Control) API.
 
 It should also be noted that a media device may also have audio
 components, like mixers, PCM capture, PCM playback, etc, which are
@@ -72,6 +74,7 @@ etc, please mail to:
     uapi/dvb/dvbapi
     uapi/rc/remote_controllers
     uapi/mediactl/media-controller
+    uapi/cec/cec-api
     uapi/gen-errors
     uapi/fdl-appendix
 
diff --git a/Documentation/media/uapi/cec/cec-api.rst b/Documentation/media/uapi/cec/cec-api.rst
new file mode 100644
index 000000000000..2aa0c50e60b3
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-api.rst
@@ -0,0 +1,94 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec:
+
+#######
+CEC API
+#######
+
+.. _cec-api:
+
+*********************************
+CEC: Consumer Electronics Control
+*********************************
+
+
+.. _cec-intro:
+
+Introduction
+============
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+HDMI connectors provide a single pin for use by the Consumer Electronics
+Control protocol. This protocol allows different devices connected by an
+HDMI cable to communicate. The protocol for CEC version 1.4 is defined
+in supplements 1 (CEC) and 2 (HEAC or HDMI Ethernet and Audio Return
+Channel) of the HDMI 1.4a (:ref:`hdmi`) specification and the
+extensions added to CEC version 2.0 are defined in chapter 11 of the
+HDMI 2.0 (:ref:`hdmi2`) specification.
+
+The bitrate is very slow (effectively no more than 36 bytes per second)
+and is based on the ancient AV.link protocol used in old SCART
+connectors. The protocol closely resembles a crazy Rube Goldberg
+contraption and is an unholy mix of low and high level messages. Some
+messages, especially those part of the HEAC protocol layered on top of
+CEC, need to be handled by the kernel, others can be handled either by
+the kernel or by userspace.
+
+In addition, CEC can be implemented in HDMI receivers, transmitters and
+in USB devices that have an HDMI input and an HDMI output and that
+control just the CEC pin.
+
+Drivers that support CEC will create a CEC device node (/dev/cecX) to
+give userspace access to the CEC adapter. The
+:ref:`CEC_ADAP_G_CAPS <cec-ioc-adap-g-caps>` ioctl will tell
+userspace what it is allowed to do.
+
+
+.. _cec-user-func:
+
+******************
+Function Reference
+******************
+
+
+.. toctree::
+    :maxdepth: 1
+
+    cec-func-open
+    cec-func-close
+    cec-func-ioctl
+    cec-func-poll
+    cec-ioc-adap-g-caps
+    cec-ioc-adap-g-log-addrs
+    cec-ioc-adap-g-phys-addr
+    cec-ioc-dqevent
+    cec-ioc-g-mode
+    cec-ioc-receive
+
+
+**********************
+Revision and Copyright
+**********************
+
+
+:author:    Verkuil Hans
+:address:   hans.verkuil@cisco.com
+:contrib:   Initial version.
+
+**Copyright** 2016 : Hans Verkuil
+
+:revision: 1.0.0 / 2016-03-17 (*hv*)
+
+Initial revision
+
+
+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
+.. from the linux kernel, refer to:
+..
+.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
+.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-func-close.rst b/Documentation/media/uapi/cec/cec-func-close.rst
new file mode 100644
index 000000000000..68e47e2aa068
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-func-close.rst
@@ -0,0 +1,57 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec-func-close:
+
+***********
+cec close()
+***********
+
+*man cec-close(2)*
+
+Close a cec device
+
+
+Synopsis
+========
+
+.. code-block:: c
+
+    #include <unistd.h>
+
+
+.. c:function:: int close( int fd )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <func-open>`.
+
+
+Description
+===========
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+Closes the cec device. Resources associated with the file descriptor are
+freed. The device configuration remain unchanged.
+
+
+Return Value
+============
+
+:c:func:`close()` returns 0 on success. On error, -1 is returned, and
+``errno`` is set appropriately. Possible error codes are:
+
+EBADF
+    ``fd`` is not a valid open file descriptor.
+
+
+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
+.. from the linux kernel, refer to:
+..
+.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
+.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
new file mode 100644
index 000000000000..9d37591e3ef4
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
@@ -0,0 +1,77 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec-func-ioctl:
+
+***********
+cec ioctl()
+***********
+
+*man cec-ioctl(2)*
+
+Control a cec device
+
+
+Synopsis
+========
+
+.. code-block:: c
+
+    #include <sys/ioctl.h>
+
+
+.. c:function:: int ioctl( int fd, int request, void *argp )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <func-open>`.
+
+``request``
+    CEC ioctl request code as defined in the cec.h header file, for
+    example CEC_ADAP_G_CAPS.
+
+``argp``
+    Pointer to a request-specific structure.
+
+
+Description
+===========
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+The :c:func:`ioctl()` function manipulates cec device parameters. The
+argument ``fd`` must be an open file descriptor.
+
+The ioctl ``request`` code specifies the cec function to be called. It
+has encoded in it whether the argument is an input, output or read/write
+parameter, and the size of the argument ``argp`` in bytes.
+
+Macros and structures definitions specifying cec ioctl requests and
+their parameters are located in the cec.h header file. All cec ioctl
+requests, their respective function and parameters are specified in
+:ref:`cec-user-func`.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+Request-specific error codes are listed in the individual requests
+descriptions.
+
+When an ioctl that takes an output or read/write parameter fails, the
+parameter remains unmodified.
+
+
+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
+.. from the linux kernel, refer to:
+..
+.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
+.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
new file mode 100644
index 000000000000..4691194ee795
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -0,0 +1,88 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec-func-open:
+
+**********
+cec open()
+**********
+
+*man cec-open(2)*
+
+Open a cec device
+
+
+Synopsis
+========
+
+.. code-block:: c
+
+    #include <fcntl.h>
+
+
+.. c:function:: int open( const char *device_name, int flags )
+
+Arguments
+=========
+
+``device_name``
+    Device to be opened.
+
+``flags``
+    Open flags. Access mode must be ``O_RDWR``.
+
+    When the ``O_NONBLOCK`` flag is given, the
+    :ref:`CEC_RECEIVE <cec-ioc-receive>` ioctl will return EAGAIN
+    error code when no message is available, and the
+    :ref:`CEC_TRANSMIT <cec-ioc-receive>`,
+    :ref:`CEC_ADAP_S_PHYS_ADDR <cec-ioc-adap-g-phys-addr>` and
+    :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>` ioctls
+    all act in non-blocking mode.
+
+    Other flags have no effect.
+
+
+Description
+===========
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+To open a cec device applications call :c:func:`open()` with the
+desired device name. The function has no side effects; the device
+configuration remain unchanged.
+
+When the device is opened in read-only mode, attempts to modify its
+configuration will result in an error, and ``errno`` will be set to
+EBADF.
+
+
+Return Value
+============
+
+:c:func:`open()` returns the new file descriptor on success. On error,
+-1 is returned, and ``errno`` is set appropriately. Possible error codes
+include:
+
+EACCES
+    The requested access to the file is not allowed.
+
+EMFILE
+    The process already has the maximum number of files open.
+
+ENFILE
+    The system limit on the total number of open files has been reached.
+
+ENOMEM
+    Insufficient kernel memory was available.
+
+ENXIO
+    No device corresponding to this device special file exists.
+
+
+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
+.. from the linux kernel, refer to:
+..
+.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
+.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
new file mode 100644
index 000000000000..ee559217c4f1
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -0,0 +1,74 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec-func-poll:
+
+**********
+cec poll()
+**********
+
+*man cec-poll(2)*
+
+Wait for some event on a file descriptor
+
+
+Synopsis
+========
+
+.. code-block:: c
+
+    #include <sys/poll.h>
+
+
+.. c:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
+
+Description
+===========
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+With the :c:func:`poll()` function applications can wait for CEC
+events.
+
+On success :c:func:`poll()` returns the number of file descriptors
+that have been selected (that is, file descriptors for which the
+``revents`` field of the respective :c:type:`struct pollfd` structure
+is non-zero). CEC devices set the ``POLLIN`` and ``POLLRDNORM`` flags in
+the ``revents`` field if there are messages in the receive queue. If the
+transmit queue has room for new messages, the ``POLLOUT`` and
+``POLLWRNORM`` flags are set. If there are events in the event queue,
+then the ``POLLPRI`` flag is set. When the function timed out it returns
+a value of zero, on failure it returns -1 and the ``errno`` variable is
+set appropriately.
+
+For more details see the :c:func:`poll()` manual page.
+
+
+Return Value
+============
+
+On success, :c:func:`poll()` returns the number structures which have
+non-zero ``revents`` fields, or zero if the call timed out. On error -1
+is returned, and the ``errno`` variable is set appropriately:
+
+EBADF
+    One or more of the ``ufds`` members specify an invalid file
+    descriptor.
+
+EFAULT
+    ``ufds`` references an inaccessible memory area.
+
+EINTR
+    The call was interrupted by a signal.
+
+EINVAL
+    The ``nfds`` argument is greater than ``OPEN_MAX``.
+
+
+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
+.. from the linux kernel, refer to:
+..
+.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
+.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
new file mode 100644
index 000000000000..e5441eca6f75
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -0,0 +1,174 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec-ioc-adap-g-caps:
+
+*********************
+ioctl CEC_ADAP_G_CAPS
+*********************
+
+*man CEC_ADAP_G_CAPS(2)*
+
+Query device capabilities
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, int request, struct cec_caps *argp )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <cec-func-open>`.
+
+``request``
+    CEC_ADAP_G_CAPS
+
+``argp``
+
+
+Description
+===========
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+All cec devices must support the ``CEC_ADAP_G_CAPS`` ioctl. To query
+device information, applications call the ioctl with a pointer to a
+struct :ref:`cec_caps <cec-caps>`. The driver fills the structure and
+returns the information to the application. The ioctl never fails.
+
+
+.. _cec-caps:
+
+.. flat-table:: struct cec_caps
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+
+    -  .. row 1
+
+       -  char
+
+       -  ``driver[32]``
+
+       -  The name of the cec adapter driver.
+
+    -  .. row 2
+
+       -  char
+
+       -  ``name[32]``
+
+       -  The name of this CEC adapter. The combination ``driver`` and
+          ``name`` must be unique.
+
+    -  .. row 3
+
+       -  __u32
+
+       -  ``capabilities``
+
+       -  The capabilities of the CEC adapter, see
+          :ref:`cec-capabilities`.
+
+    -  .. row 4
+
+       -  __u32
+
+       -  ``version``
+
+       -  CEC Framework API version, formatted with the ``KERNEL_VERSION()``
+          macro.
+
+
+
+.. _cec-capabilities:
+
+.. flat-table:: CEC Capabilities Flags
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. row 1
+
+       -  ``CEC_CAP_PHYS_ADDR``
+
+       -  0x00000001
+
+       -  Userspace has to configure the physical address by calling
+          :ref:`CEC_ADAP_S_PHYS_ADDR <cec-ioc-adap-g-phys-addr>`. If
+          this capability isn't set, then setting the physical address is
+          handled by the kernel whenever the EDID is set (for an HDMI
+          receiver) or read (for an HDMI transmitter).
+
+    -  .. row 2
+
+       -  ``CEC_CAP_LOG_ADDRS``
+
+       -  0x00000002
+
+       -  Userspace has to configure the logical addresses by calling
+          :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>`. If
+          this capability isn't set, then the kernel will have configured
+          this.
+
+    -  .. row 3
+
+       -  ``CEC_CAP_TRANSMIT``
+
+       -  0x00000004
+
+       -  Userspace can transmit CEC messages by calling
+          :ref:`CEC_TRANSMIT <cec-ioc-receive>`. This implies that
+          userspace can be a follower as well, since being able to transmit
+          messages is a prerequisite of becoming a follower. If this
+          capability isn't set, then the kernel will handle all CEC
+          transmits and process all CEC messages it receives.
+
+    -  .. row 4
+
+       -  ``CEC_CAP_PASSTHROUGH``
+
+       -  0x00000008
+
+       -  Userspace can use the passthrough mode by calling
+          :ref:`CEC_S_MODE <cec-ioc-g-mode>`.
+
+    -  .. row 5
+
+       -  ``CEC_CAP_RC``
+
+       -  0x00000010
+
+       -  This adapter supports the remote control protocol.
+
+    -  .. row 6
+
+       -  ``CEC_CAP_MONITOR_ALL``
+
+       -  0x00000020
+
+       -  The CEC hardware can monitor all messages, not just directed and
+          broadcast messages.
+
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
+.. from the linux kernel, refer to:
+..
+.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
+.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
new file mode 100644
index 000000000000..70fd5b96ecc1
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -0,0 +1,427 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec-ioc-adap-g-log-addrs:
+
+************************************************
+ioctl CEC_ADAP_G_LOG_ADDRS, CEC_ADAP_S_LOG_ADDRS
+************************************************
+
+*man CEC_ADAP_G_LOG_ADDRS(2)*
+
+CEC_ADAP_S_LOG_ADDRS
+Get or set the logical addresses
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, int request, struct cec_log_addrs *argp )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <cec-func-open>`.
+
+``request``
+    CEC_ADAP_G_LOG_ADDRS, CEC_ADAP_S_LOG_ADDRS
+
+``argp``
+
+
+Description
+===========
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+To query the current CEC logical addresses, applications call the
+``CEC_ADAP_G_LOG_ADDRS`` ioctl with a pointer to a
+:c:type:`struct cec_log_addrs` structure where the drivers stores
+the logical addresses.
+
+To set new logical addresses, applications fill in struct
+:c:type:`struct cec_log_addrs` and call the ``CEC_ADAP_S_LOG_ADDRS``
+ioctl with a pointer to this struct. The ``CEC_ADAP_S_LOG_ADDRS`` ioctl
+is only available if ``CEC_CAP_LOG_ADDRS`` is set (ENOTTY error code is
+returned otherwise). This ioctl will block until all requested logical
+addresses have been claimed. ``CEC_ADAP_S_LOG_ADDRS`` can only be called
+by a file handle in initiator mode (see
+:ref:`CEC_S_MODE <cec-ioc-g-mode>`).
+
+
+.. _cec-log-addrs:
+
+.. flat-table:: struct cec_log_addrs
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+
+    -  .. row 1
+
+       -  __u8
+
+       -  ``log_addr`` [CEC_MAX_LOG_ADDRS]
+
+       -  The actual logical addresses that were claimed. This is set by the
+          driver. If no logical address could be claimed, then it is set to
+          ``CEC_LOG_ADDR_INVALID``. If this adapter is Unregistered, then
+          ``log_addr[0]`` is set to 0xf and all others to
+          ``CEC_LOG_ADDR_INVALID``.
+
+    -  .. row 2
+
+       -  __u16
+
+       -  ``log_addr_mask``
+
+       -  The bitmask of all logical addresses this adapter has claimed. If
+          this adapter is Unregistered then ``log_addr_mask`` sets bit 15
+          and clears all other bits. If this adapter is not configured at
+          all, then ``log_addr_mask`` is set to 0. Set by the driver.
+
+    -  .. row 3
+
+       -  __u8
+
+       -  ``cec_version``
+
+       -  The CEC version that this adapter shall use. See
+          :ref:`cec-versions`. Used to implement the
+          ``CEC_MSG_CEC_VERSION`` and ``CEC_MSG_REPORT_FEATURES`` messages.
+          Note that ``CEC_OP_CEC_VERSION_1_3A`` is not allowed by the CEC
+          framework.
+
+    -  .. row 4
+
+       -  __u8
+
+       -  ``num_log_addrs``
+
+       -  Number of logical addresses to set up. Must be ≤
+          ``available_log_addrs`` as returned by
+          :ref:`CEC_ADAP_G_CAPS <cec-ioc-adap-g-caps>`. All arrays in
+          this structure are only filled up to index
+          ``available_log_addrs``-1. The remaining array elements will be
+          ignored. Note that the CEC 2.0 standard allows for a maximum of 2
+          logical addresses, although some hardware has support for more.
+          ``CEC_MAX_LOG_ADDRS`` is 4. The driver will return the actual
+          number of logical addresses it could claim, which may be less than
+          what was requested. If this field is set to 0, then the CEC
+          adapter shall clear all claimed logical addresses and all other
+          fields will be ignored.
+
+    -  .. row 5
+
+       -  __u32
+
+       -  ``vendor_id``
+
+       -  The vendor ID is a 24-bit number that identifies the specific
+          vendor or entity. Based on this ID vendor specific commands may be
+          defined. If you do not want a vendor ID then set it to
+          ``CEC_VENDOR_ID_NONE``.
+
+    -  .. row 6
+
+       -  __u32
+
+       -  ``flags``
+
+       -  Flags. No flags are defined yet, so set this to 0.
+
+    -  .. row 7
+
+       -  char
+
+       -  ``osd_name``\ [15]
+
+       -  The On-Screen Display name as is returned by the
+          ``CEC_MSG_SET_OSD_NAME`` message.
+
+    -  .. row 8
+
+       -  __u8
+
+       -  ``primary_device_type`` [CEC_MAX_LOG_ADDRS]
+
+       -  Primary device type for each logical address. See
+          :ref:`cec-prim-dev-types` for possible types.
+
+    -  .. row 9
+
+       -  __u8
+
+       -  ``log_addr_type`` [CEC_MAX_LOG_ADDRS]
+
+       -  Logical address types. See :ref:`cec-log-addr-types` for
+          possible types. The driver will update this with the actual
+          logical address type that it claimed (e.g. it may have to fallback
+          to ``CEC_LOG_ADDR_TYPE_UNREGISTERED``).
+
+    -  .. row 10
+
+       -  __u8
+
+       -  ``all_device_types`` [CEC_MAX_LOG_ADDRS]
+
+       -  CEC 2.0 specific: all device types. See
+          :ref:`cec-all-dev-types-flags`. Used to implement the
+          ``CEC_MSG_REPORT_FEATURES`` message. This field is ignored if
+          ``cec_version`` < ``CEC_OP_CEC_VERSION_2_0``.
+
+    -  .. row 11
+
+       -  __u8
+
+       -  ``features`` [CEC_MAX_LOG_ADDRS][12]
+
+       -  Features for each logical address. Used to implement the
+          ``CEC_MSG_REPORT_FEATURES`` message. The 12 bytes include both the
+          RC Profile and the Device Features. This field is ignored if
+          ``cec_version`` < ``CEC_OP_CEC_VERSION_2_0``.
+
+
+
+.. _cec-versions:
+
+.. flat-table:: CEC Versions
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. row 1
+
+       -  ``CEC_OP_CEC_VERSION_1_3A``
+
+       -  4
+
+       -  CEC version according to the HDMI 1.3a standard.
+
+    -  .. row 2
+
+       -  ``CEC_OP_CEC_VERSION_1_4B``
+
+       -  5
+
+       -  CEC version according to the HDMI 1.4b standard.
+
+    -  .. row 3
+
+       -  ``CEC_OP_CEC_VERSION_2_0``
+
+       -  6
+
+       -  CEC version according to the HDMI 2.0 standard.
+
+
+
+.. _cec-prim-dev-types:
+
+.. flat-table:: CEC Primary Device Types
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. row 1
+
+       -  ``CEC_OP_PRIM_DEVTYPE_TV``
+
+       -  0
+
+       -  Use for a TV.
+
+    -  .. row 2
+
+       -  ``CEC_OP_PRIM_DEVTYPE_RECORD``
+
+       -  1
+
+       -  Use for a recording device.
+
+    -  .. row 3
+
+       -  ``CEC_OP_PRIM_DEVTYPE_TUNER``
+
+       -  3
+
+       -  Use for a device with a tuner.
+
+    -  .. row 4
+
+       -  ``CEC_OP_PRIM_DEVTYPE_PLAYBACK``
+
+       -  4
+
+       -  Use for a playback device.
+
+    -  .. row 5
+
+       -  ``CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM``
+
+       -  5
+
+       -  Use for an audio system (e.g. an audio/video receiver).
+
+    -  .. row 6
+
+       -  ``CEC_OP_PRIM_DEVTYPE_SWITCH``
+
+       -  6
+
+       -  Use for a CEC switch.
+
+    -  .. row 7
+
+       -  ``CEC_OP_PRIM_DEVTYPE_VIDEOPROC``
+
+       -  7
+
+       -  Use for a video processor device.
+
+
+
+.. _cec-log-addr-types:
+
+.. flat-table:: CEC Logical Address Types
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. row 1
+
+       -  ``CEC_LOG_ADDR_TYPE_TV``
+
+       -  0
+
+       -  Use for a TV.
+
+    -  .. row 2
+
+       -  ``CEC_LOG_ADDR_TYPE_RECORD``
+
+       -  1
+
+       -  Use for a recording device.
+
+    -  .. row 3
+
+       -  ``CEC_LOG_ADDR_TYPE_TUNER``
+
+       -  2
+
+       -  Use for a tuner device.
+
+    -  .. row 4
+
+       -  ``CEC_LOG_ADDR_TYPE_PLAYBACK``
+
+       -  3
+
+       -  Use for a playback device.
+
+    -  .. row 5
+
+       -  ``CEC_LOG_ADDR_TYPE_AUDIOSYSTEM``
+
+       -  4
+
+       -  Use for an audio system device.
+
+    -  .. row 6
+
+       -  ``CEC_LOG_ADDR_TYPE_SPECIFIC``
+
+       -  5
+
+       -  Use for a second TV or for a video processor device.
+
+    -  .. row 7
+
+       -  ``CEC_LOG_ADDR_TYPE_UNREGISTERED``
+
+       -  6
+
+       -  Use this if you just want to remain unregistered. Used for pure
+          CEC switches or CDC-only devices (CDC: Capability Discovery and
+          Control).
+
+
+
+.. _cec-all-dev-types-flags:
+
+.. flat-table:: CEC All Device Types Flags
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. row 1
+
+       -  ``CEC_OP_ALL_DEVTYPE_TV``
+
+       -  0x80
+
+       -  This supports the TV type.
+
+    -  .. row 2
+
+       -  ``CEC_OP_ALL_DEVTYPE_RECORD``
+
+       -  0x40
+
+       -  This supports the Recording type.
+
+    -  .. row 3
+
+       -  ``CEC_OP_ALL_DEVTYPE_TUNER``
+
+       -  0x20
+
+       -  This supports the Tuner type.
+
+    -  .. row 4
+
+       -  ``CEC_OP_ALL_DEVTYPE_PLAYBACK``
+
+       -  0x10
+
+       -  This supports the Playback type.
+
+    -  .. row 5
+
+       -  ``CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM``
+
+       -  0x08
+
+       -  This supports the Audio System type.
+
+    -  .. row 6
+
+       -  ``CEC_OP_ALL_DEVTYPE_SWITCH``
+
+       -  0x04
+
+       -  This supports the CEC Switch or Video Processing type.
+
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
+.. from the linux kernel, refer to:
+..
+.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
+.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
new file mode 100644
index 000000000000..e6a34d9afd13
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -0,0 +1,78 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec-ioc-adap-g-phys-addr:
+
+************************************************
+ioctl CEC_ADAP_G_PHYS_ADDR, CEC_ADAP_S_PHYS_ADDR
+************************************************
+
+*man CEC_ADAP_G_PHYS_ADDR(2)*
+
+CEC_ADAP_S_PHYS_ADDR
+Get or set the physical address
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, int request, __u16 *argp )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <cec-func-open>`.
+
+``request``
+    CEC_ADAP_G_PHYS_ADDR, CEC_ADAP_S_PHYS_ADDR
+
+``argp``
+
+
+Description
+===========
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+To query the current physical address applications call the
+``CEC_ADAP_G_PHYS_ADDR`` ioctl with a pointer to an __u16 where the
+driver stores the physical address.
+
+To set a new physical address applications store the physical address in
+an __u16 and call the ``CEC_ADAP_S_PHYS_ADDR`` ioctl with a pointer to
+this integer. ``CEC_ADAP_S_PHYS_ADDR`` is only available if
+``CEC_CAP_PHYS_ADDR`` is set (ENOTTY error code will be returned
+otherwise). ``CEC_ADAP_S_PHYS_ADDR`` can only be called by a file handle
+in initiator mode (see :ref:`CEC_S_MODE <cec-ioc-g-mode>`), if not
+EBUSY error code will be returned.
+
+The physical address is a 16-bit number where each group of 4 bits
+represent a digit of the physical address a.b.c.d where the most
+significant 4 bits represent 'a'. The CEC root device (usually the TV)
+has address 0.0.0.0. Every device that is hooked up to an input of the
+TV has address a.0.0.0 (where 'a' is ≥ 1), devices hooked up to those in
+turn have addresses a.b.0.0, etc. So a topology of up to 5 devices deep
+is supported. The physical address a device shall use is stored in the
+EDID of the sink.
+
+For example, the EDID for each HDMI input of the TV will have a
+different physical address of the form a.0.0.0 that the sources will
+read out and use as their physical address.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
+.. from the linux kernel, refer to:
+..
+.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
+.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
new file mode 100644
index 000000000000..832627bb0a90
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -0,0 +1,237 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec-ioc-g-event:
+
+*****************
+ioctl CEC_DQEVENT
+*****************
+
+*man CEC_DQEVENT(2)*
+
+Dequeue a CEC event
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, int request, struct cec_event *argp )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <cec-func-open>`.
+
+``request``
+    CEC_DQEVENT
+
+``argp``
+
+
+Description
+===========
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+CEC devices can send asynchronous events. These can be retrieved by
+calling the ``CEC_DQEVENT`` ioctl. If the file descriptor is in
+non-blocking mode and no event is pending, then it will return -1 and
+set errno to the EAGAIN error code.
+
+The internal event queues are per-filehandle and per-event type. If
+there is no more room in a queue then the last event is overwritten with
+the new one. This means that intermediate results can be thrown away but
+that the latest event is always available. This also means that is it
+possible to read two successive events that have the same value (e.g.
+two CEC_EVENT_STATE_CHANGE events with the same state). In that case
+the intermediate state changes were lost but it is guaranteed that the
+state did change in between the two events.
+
+
+.. _cec-event-state-change:
+
+.. flat-table:: struct cec_event_state_change
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+
+    -  .. row 1
+
+       -  __u16
+
+       -  ``phys_addr``
+
+       -  The current physical address.
+
+    -  .. row 2
+
+       -  __u16
+
+       -  ``log_addr_mask``
+
+       -  The current set of claimed logical addresses.
+
+
+
+.. _cec-event-lost-msgs:
+
+.. flat-table:: struct cec_event_lost_msgs
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+
+    -  .. row 1
+
+       -  __u32
+
+       -  ``lost_msgs``
+
+       -  Set to the number of lost messages since the filehandle was opened
+          or since the last time this event was dequeued for this
+          filehandle. The messages lost are the oldest messages. So when a
+          new message arrives and there is no more room, then the oldest
+          message is discarded to make room for the new one. The internal
+          size of the message queue guarantees that all messages received in
+          the last two seconds will be stored. Since messages should be
+          replied to within a second according to the CEC specification,
+          this is more than enough.
+
+
+
+.. _cec-event:
+
+.. flat-table:: struct cec_event
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2 1
+
+
+    -  .. row 1
+
+       -  __u64
+
+       -  ``ts``
+
+       -  Timestamp of the event in ns.
+
+       -
+
+    -  .. row 2
+
+       -  __u32
+
+       -  ``event``
+
+       -  The CEC event type, see :ref:`cec-events`.
+
+       -
+
+    -  .. row 3
+
+       -  __u32
+
+       -  ``flags``
+
+       -  Event flags, see :ref:`cec-event-flags`.
+
+       -
+
+    -  .. row 4
+
+       -  union
+
+       -  (anonymous)
+
+       -
+       -
+
+    -  .. row 5
+
+       -
+       -  struct cec_event_state_change
+
+       -  ``state_change``
+
+       -  The new adapter state as sent by the ``CEC_EVENT_STATE_CHANGE``
+          event.
+
+    -  .. row 6
+
+       -
+       -  struct cec_event_lost_msgs
+
+       -  ``lost_msgs``
+
+       -  The number of lost messages as sent by the ``CEC_EVENT_LOST_MSGS``
+          event.
+
+
+
+.. _cec-events:
+
+.. flat-table:: CEC Events Types
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. row 1
+
+       -  ``CEC_EVENT_STATE_CHANGE``
+
+       -  1
+
+       -  Generated when the CEC Adapter's state changes. When open() is
+          called an initial event will be generated for that filehandle with
+          the CEC Adapter's state at that time.
+
+    -  .. row 2
+
+       -  ``CEC_EVENT_LOST_MSGS``
+
+       -  2
+
+       -  Generated if one or more CEC messages were lost because the
+          application didn't dequeue CEC messages fast enough.
+
+
+
+.. _cec-event-flags:
+
+.. flat-table:: CEC Event Flags
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. row 1
+
+       -  ``CEC_EVENT_FL_INITIAL_VALUE``
+
+       -  1
+
+       -  Set for the initial events that are generated when the device is
+          opened. See the table above for which events do this. This allows
+          applications to learn the initial state of the CEC adapter at
+          open() time.
+
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
+.. from the linux kernel, refer to:
+..
+.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
+.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
new file mode 100644
index 000000000000..f38c28755d8f
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -0,0 +1,311 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec-ioc-g-mode:
+
+****************************
+ioctl CEC_G_MODE, CEC_S_MODE
+****************************
+
+*man CEC_G_MODE(2)*
+
+CEC_S_MODE
+Get or set exclusive use of the CEC adapter
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, int request, __u32 *argp )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <cec-func-open>`.
+
+``request``
+    CEC_G_MODE, CEC_S_MODE
+
+``argp``
+
+
+Description
+===========
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+By default any filehandle can use
+:ref:`CEC_TRANSMIT <cec-ioc-receive>` and
+:ref:`CEC_RECEIVE <cec-ioc-receive>`, but in order to prevent
+applications from stepping on each others toes it must be possible to
+obtain exclusive access to the CEC adapter. This ioctl sets the
+filehandle to initiator and/or follower mode which can be exclusive
+depending on the chosen mode. The initiator is the filehandle that is
+used to initiate messages, i.e. it commands other CEC devices. The
+follower is the filehandle that receives messages sent to the CEC
+adapter and processes them. The same filehandle can be both initiator
+and follower, or this role can be taken by two different filehandles.
+
+When a CEC message is received, then the CEC framework will decide how
+it will be processed. If the message is a reply to an earlier
+transmitted message, then the reply is sent back to the filehandle that
+is waiting for it. In addition the CEC framework will process it.
+
+If the message is not a reply, then the CEC framework will process it
+first. If there is no follower, then the message is just discarded and a
+feature abort is sent back to the initiator if the framework couldn't
+process it. If there is a follower, then the message is passed on to the
+follower who will use :ref:`CEC_RECEIVE <cec-ioc-receive>` to dequeue
+the new message. The framework expects the follower to make the right
+decisions.
+
+The CEC framework will process core messages unless requested otherwise
+by the follower. The follower can enable the passthrough mode. In that
+case, the CEC framework will pass on most core messages without
+processing them and the follower will have to implement those messages.
+There are some messages that the core will always process, regardless of
+the passthrough mode. See :ref:`cec-core-processing` for details.
+
+If there is no initiator, then any CEC filehandle can use
+:ref:`CEC_TRANSMIT <cec-ioc-receive>`. If there is an exclusive
+initiator then only that initiator can call
+:ref:`CEC_TRANSMIT <cec-ioc-receive>`. The follower can of course
+always call :ref:`CEC_TRANSMIT <cec-ioc-receive>`.
+
+Available initiator modes are:
+
+
+.. _cec-mode-initiator:
+
+.. flat-table:: Initiator Modes
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. row 1
+
+       -  ``CEC_MODE_NO_INITIATOR``
+
+       -  0x0
+
+       -  This is not an initiator, i.e. it cannot transmit CEC messages or
+          make any other changes to the CEC adapter.
+
+    -  .. row 2
+
+       -  ``CEC_MODE_INITIATOR``
+
+       -  0x1
+
+       -  This is an initiator (the default when the device is opened) and
+          it can transmit CEC messages and make changes to the CEC adapter,
+          unless there is an exclusive initiator.
+
+    -  .. row 3
+
+       -  ``CEC_MODE_EXCL_INITIATOR``
+
+       -  0x2
+
+       -  This is an exclusive initiator and this file descriptor is the
+          only one that can transmit CEC messages and make changes to the
+          CEC adapter. If someone else is already the exclusive initiator
+          then an attempt to become one will return the EBUSY error code
+          error.
+
+
+Available follower modes are:
+
+
+.. _cec-mode-follower:
+
+.. flat-table:: Follower Modes
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. row 1
+
+       -  ``CEC_MODE_NO_FOLLOWER``
+
+       -  0x00
+
+       -  This is not a follower (the default when the device is opened).
+
+    -  .. row 2
+
+       -  ``CEC_MODE_FOLLOWER``
+
+       -  0x10
+
+       -  This is a follower and it will receive CEC messages unless there
+          is an exclusive follower. You cannot become a follower if
+          ``CEC_CAP_TRANSMIT`` is not set or if ``CEC_MODE_NO_INITIATOR``
+          was specified, EINVAL error code is returned in that case.
+
+    -  .. row 3
+
+       -  ``CEC_MODE_EXCL_FOLLOWER``
+
+       -  0x20
+
+       -  This is an exclusive follower and only this file descriptor will
+          receive CEC messages for processing. If someone else is already
+          the exclusive follower then an attempt to become one will return
+          the EBUSY error code error. You cannot become a follower if
+          ``CEC_CAP_TRANSMIT`` is not set or if ``CEC_MODE_NO_INITIATOR``
+          was specified, EINVAL error code is returned in that case.
+
+    -  .. row 4
+
+       -  ``CEC_MODE_EXCL_FOLLOWER_PASSTHRU``
+
+       -  0x30
+
+       -  This is an exclusive follower and only this file descriptor will
+          receive CEC messages for processing. In addition it will put the
+          CEC device into passthrough mode, allowing the exclusive follower
+          to handle most core messages instead of relying on the CEC
+          framework for that. If someone else is already the exclusive
+          follower then an attempt to become one will return the EBUSY error
+          code error. You cannot become a follower if ``CEC_CAP_TRANSMIT``
+          is not set or if ``CEC_MODE_NO_INITIATOR`` was specified, EINVAL
+          error code is returned in that case.
+
+    -  .. row 5
+
+       -  ``CEC_MODE_MONITOR``
+
+       -  0xe0
+
+       -  Put the file descriptor into monitor mode. Can only be used in
+          combination with ``CEC_MODE_NO_INITIATOR``, otherwise EINVAL error
+          code will be returned. In monitor mode all messages this CEC
+          device transmits and all messages it receives (both broadcast
+          messages and directed messages for one its logical addresses) will
+          be reported. This is very useful for debugging. This is only
+          allowed if the process has the ``CAP_NET_ADMIN`` capability. If
+          that is not set, then EPERM error code is returned.
+
+    -  .. row 6
+
+       -  ``CEC_MODE_MONITOR_ALL``
+
+       -  0xf0
+
+       -  Put the file descriptor into 'monitor all' mode. Can only be used
+          in combination with ``CEC_MODE_NO_INITIATOR``, otherwise EINVAL
+          error code will be returned. In 'monitor all' mode all messages
+          this CEC device transmits and all messages it receives, including
+          directed messages for other CEC devices will be reported. This is
+          very useful for debugging, but not all devices support this. This
+          mode requires that the ``CEC_CAP_MONITOR_ALL`` capability is set,
+          otherwise EINVAL error code is returned. This is only allowed if
+          the process has the ``CAP_NET_ADMIN`` capability. If that is not
+          set, then EPERM error code is returned.
+
+
+Core message processing details:
+
+
+.. _cec-core-processing:
+
+.. flat-table:: Core Message Processing
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``CEC_MSG_GET_CEC_VERSION``
+
+       -  When in passthrough mode this message has to be handled by
+          userspace, otherwise the core will return the CEC version that was
+          set with
+          :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>`.
+
+    -  .. row 2
+
+       -  ``CEC_MSG_GIVE_DEVICE_VENDOR_ID``
+
+       -  When in passthrough mode this message has to be handled by
+          userspace, otherwise the core will return the vendor ID that was
+          set with
+          :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>`.
+
+    -  .. row 3
+
+       -  ``CEC_MSG_ABORT``
+
+       -  When in passthrough mode this message has to be handled by
+          userspace, otherwise the core will return a feature refused
+          message as per the specification.
+
+    -  .. row 4
+
+       -  ``CEC_MSG_GIVE_PHYSICAL_ADDR``
+
+       -  When in passthrough mode this message has to be handled by
+          userspace, otherwise the core will report the current physical
+          address.
+
+    -  .. row 5
+
+       -  ``CEC_MSG_GIVE_OSD_NAME``
+
+       -  When in passthrough mode this message has to be handled by
+          userspace, otherwise the core will report the current OSD name as
+          was set with
+          :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>`.
+
+    -  .. row 6
+
+       -  ``CEC_MSG_GIVE_FEATURES``
+
+       -  When in passthrough mode this message has to be handled by
+          userspace, otherwise the core will report the current features as
+          was set with
+          :ref:`CEC_ADAP_S_LOG_ADDRS <cec-ioc-adap-g-log-addrs>` or
+          the message is ignore if the CEC version was older than 2.0.
+
+    -  .. row 7
+
+       -  ``CEC_MSG_USER_CONTROL_PRESSED``
+
+       -  If ``CEC_CAP_RC`` is set, then generate a remote control key
+          press. This message is always passed on to userspace.
+
+    -  .. row 8
+
+       -  ``CEC_MSG_USER_CONTROL_RELEASED``
+
+       -  If ``CEC_CAP_RC`` is set, then generate a remote control key
+          release. This message is always passed on to userspace.
+
+    -  .. row 9
+
+       -  ``CEC_MSG_REPORT_PHYSICAL_ADDR``
+
+       -  The CEC framework will make note of the reported physical address
+          and then just pass the message on to userspace.
+
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
+.. from the linux kernel, refer to:
+..
+.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
+.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
new file mode 100644
index 000000000000..5b303a1e6691
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -0,0 +1,329 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec-ioc-receive:
+
+*******************************
+ioctl CEC_RECEIVE, CEC_TRANSMIT
+*******************************
+
+*man CEC_RECEIVE(2)*
+
+CEC_TRANSMIT
+Receive or transmit a CEC message
+
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, int request, struct cec_msg *argp )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <cec-func-open>`.
+
+``request``
+    CEC_RECEIVE, CEC_TRANSMIT
+
+``argp``
+
+
+Description
+===========
+
+Note: this documents the proposed CEC API. This API is not yet finalized
+and is currently only available as a staging kernel module.
+
+To receive a CEC message the application has to fill in the
+:c:type:`struct cec_msg` structure and pass it to the ``CEC_RECEIVE``
+ioctl. ``CEC_RECEIVE`` is only available if ``CEC_CAP_RECEIVE`` is set.
+If the file descriptor is in non-blocking mode and there are no received
+messages pending, then it will return -1 and set errno to the EAGAIN
+error code. If the file descriptor is in blocking mode and ``timeout``
+is non-zero and no message arrived within ``timeout`` milliseconds, then
+it will return -1 and set errno to the ETIMEDOUT error code.
+
+To send a CEC message the application has to fill in the
+:c:type:`struct cec_msg` structure and pass it to the
+``CEC_TRANSMIT`` ioctl. ``CEC_TRANSMIT`` is only available if
+``CEC_CAP_TRANSMIT`` is set. If there is no more room in the transmit
+queue, then it will return -1 and set errno to the EBUSY error code.
+
+
+.. _cec-msg:
+
+.. flat-table:: struct cec_msg
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+
+    -  .. row 1
+
+       -  __u64
+
+       -  ``ts``
+
+       -  Timestamp of when the message was transmitted in ns in the case of
+          ``CEC_TRANSMIT`` with ``reply`` set to 0, or the timestamp of the
+          received message in all other cases.
+
+    -  .. row 2
+
+       -  __u32
+
+       -  ``len``
+
+       -  The length of the message. For ``CEC_TRANSMIT`` this is filled in
+          by the application. The driver will fill this in for
+          ``CEC_RECEIVE`` and for ``CEC_TRANSMIT`` it will be filled in with
+          the length of the reply message if ``reply`` was set.
+
+    -  .. row 3
+
+       -  __u32
+
+       -  ``timeout``
+
+       -  The timeout in milliseconds. This is the time the device will wait
+          for a message to be received before timing out. If it is set to 0,
+          then it will wait indefinitely when it is called by
+          ``CEC_RECEIVE``. If it is 0 and it is called by ``CEC_TRANSMIT``,
+          then it will be replaced by 1000 if the ``reply`` is non-zero or
+          ignored if ``reply`` is 0.
+
+    -  .. row 4
+
+       -  __u32
+
+       -  ``sequence``
+
+       -  The sequence number is automatically assigned by the CEC framework
+          for all transmitted messages. It can be later used by the
+          framework to generate an event if a reply for a message was
+          requested and the message was transmitted in a non-blocking mode.
+
+    -  .. row 5
+
+       -  __u32
+
+       -  ``flags``
+
+       -  Flags. No flags are defined yet, so set this to 0.
+
+    -  .. row 6
+
+       -  __u8
+
+       -  ``rx_status``
+
+       -  The status bits of the received message. See
+          :ref:`cec-rx-status` for the possible status values. It is 0 if
+          this message was transmitted, not received, unless this is the
+          reply to a transmitted message. In that case both ``rx_status``
+          and ``tx_status`` are set.
+
+    -  .. row 7
+
+       -  __u8
+
+       -  ``tx_status``
+
+       -  The status bits of the transmitted message. See
+          :ref:`cec-tx-status` for the possible status values. It is 0 if
+          this messages was received, not transmitted.
+
+    -  .. row 8
+
+       -  __u8
+
+       -  ``msg``\ [16]
+
+       -  The message payload. For ``CEC_TRANSMIT`` this is filled in by the
+          application. The driver will fill this in for ``CEC_RECEIVE`` and
+          for ``CEC_TRANSMIT`` it will be filled in with the payload of the
+          reply message if ``reply`` was set.
+
+    -  .. row 9
+
+       -  __u8
+
+       -  ``reply``
+
+       -  Wait until this message is replied. If ``reply`` is 0 and the
+          ``timeout`` is 0, then don't wait for a reply but return after
+          transmitting the message. If there was an error as indicated by a
+          non-zero ``tx_status`` field, then ``reply`` and ``timeout`` are
+          both set to 0 by the driver. Ignored by ``CEC_RECEIVE``. The case
+          where ``reply`` is 0 (this is the opcode for the Feature Abort
+          message) and ``timeout`` is non-zero is specifically allowed to
+          send a message and wait up to ``timeout`` milliseconds for a
+          Feature Abort reply. In this case ``rx_status`` will either be set
+          to ``CEC_RX_STATUS_TIMEOUT`` or ``CEC_RX_STATUS_FEATURE_ABORT``.
+
+    -  .. row 10
+
+       -  __u8
+
+       -  ``tx_arb_lost_cnt``
+
+       -  A counter of the number of transmit attempts that resulted in the
+          Arbitration Lost error. This is only set if the hardware supports
+          this, otherwise it is always 0. This counter is only valid if the
+          ``CEC_TX_STATUS_ARB_LOST`` status bit is set.
+
+    -  .. row 11
+
+       -  __u8
+
+       -  ``tx_nack_cnt``
+
+       -  A counter of the number of transmit attempts that resulted in the
+          Not Acknowledged error. This is only set if the hardware supports
+          this, otherwise it is always 0. This counter is only valid if the
+          ``CEC_TX_STATUS_NACK`` status bit is set.
+
+    -  .. row 12
+
+       -  __u8
+
+       -  ``tx_low_drive_cnt``
+
+       -  A counter of the number of transmit attempts that resulted in the
+          Arbitration Lost error. This is only set if the hardware supports
+          this, otherwise it is always 0. This counter is only valid if the
+          ``CEC_TX_STATUS_LOW_DRIVE`` status bit is set.
+
+    -  .. row 13
+
+       -  __u8
+
+       -  ``tx_error_cnt``
+
+       -  A counter of the number of transmit errors other than Arbitration
+          Lost or Not Acknowledged. This is only set if the hardware
+          supports this, otherwise it is always 0. This counter is only
+          valid if the ``CEC_TX_STATUS_ERROR`` status bit is set.
+
+
+
+.. _cec-tx-status:
+
+.. flat-table:: CEC Transmit Status
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. row 1
+
+       -  ``CEC_TX_STATUS_OK``
+
+       -  0x01
+
+       -  The message was transmitted successfully. This is mutually
+          exclusive with ``CEC_TX_STATUS_MAX_RETRIES``. Other bits can still
+          be set if earlier attempts met with failure before the transmit
+          was eventually successful.
+
+    -  .. row 2
+
+       -  ``CEC_TX_STATUS_ARB_LOST``
+
+       -  0x02
+
+       -  CEC line arbitration was lost.
+
+    -  .. row 3
+
+       -  ``CEC_TX_STATUS_NACK``
+
+       -  0x04
+
+       -  Message was not acknowledged.
+
+    -  .. row 4
+
+       -  ``CEC_TX_STATUS_LOW_DRIVE``
+
+       -  0x08
+
+       -  Low drive was detected on the CEC bus. This indicates that a
+          follower detected an error on the bus and requests a
+          retransmission.
+
+    -  .. row 5
+
+       -  ``CEC_TX_STATUS_ERROR``
+
+       -  0x10
+
+       -  Some error occurred. This is used for any errors that do not fit
+          the previous two, either because the hardware could not tell which
+          error occurred, or because the hardware tested for other
+          conditions besides those two.
+
+    -  .. row 6
+
+       -  ``CEC_TX_STATUS_MAX_RETRIES``
+
+       -  0x20
+
+       -  The transmit failed after one or more retries. This status bit is
+          mutually exclusive with ``CEC_TX_STATUS_OK``. Other bits can still
+          be set to explain which failures were seen.
+
+
+
+.. _cec-rx-status:
+
+.. flat-table:: CEC Receive Status
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    -  .. row 1
+
+       -  ``CEC_RX_STATUS_OK``
+
+       -  0x01
+
+       -  The message was received successfully.
+
+    -  .. row 2
+
+       -  ``CEC_RX_STATUS_TIMEOUT``
+
+       -  0x02
+
+       -  The reply to an earlier transmitted message timed out.
+
+    -  .. row 3
+
+       -  ``CEC_RX_STATUS_FEATURE_ABORT``
+
+       -  0x04
+
+       -  The message was received successfully but the reply was
+          ``CEC_MSG_FEATURE_ABORT``. This status is only set if this message
+          was the reply to an earlier transmitted message.
+
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
+.. from the linux kernel, refer to:
+..
+.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
+.. ------------------------------------------------------------------------------
diff --git a/Documentation/media/uapi/v4l/biblio.rst b/Documentation/media/uapi/v4l/biblio.rst
index e911df972d40..1cedcfc04327 100644
--- a/Documentation/media/uapi/v4l/biblio.rst
+++ b/Documentation/media/uapi/v4l/biblio.rst
@@ -349,6 +349,16 @@ HDMI
 
 :author:    HDMI Licensing LLC (http://www.hdmi.org)
 
+.. _hdmi2:
+
+HDMI2
+=====
+
+:title:     High-Definition Multimedia Interface
+:subtitle:  Specification Version 2.0
+
+:author:    HDMI Licensing LLC (http://www.hdmi.org)
+
 .. _dp:
 
 DP
-- 
2.7.4

