Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50147 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2HKSGR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 14:06:17 -0400
Message-ID: <50269F15.4030504@gmail.com>
Date: Sat, 11 Aug 2012 20:06:13 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>,
	oselas@community.pengutronix.de,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: [PATCH 0/1] S3C244X/S3C64XX SoC camera host interface driver
Content-Type: multipart/mixed;
 boundary="------------080801060203010109090002"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080801060203010109090002
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi all,

This patch adds a driver for Samsung S3C244X/S3C64XX SoC series camera host 
interface. My intention was to create a V4L2 driver that would work with 
standard applications like Gstreamer or mplayer, and yet exposing possibly 
all features available in the hardware.

It took me several weeks to do this work in my (limited) spare time. 
Finally I've got something that is functional and I think might be useful 
for others, so I'm publishing this initial version. It hopefully doesn't 
need much tweaking or corrections, at least as far as S3C244X is concerned. 
It has not been tested on S3C64XX SoCs, as I don't have the hardware. 
However, the driver has been designed with covering S3C64XX as well in mind, 
and I've already taken care of some differences between S3C2444X and S3C64XX.
Mem-to-mem features are not yet supported, but these are quite separate 
issue and could be easily added as a next step. 

The patch to follow only adds the CAMIF driver, the other two required for
the camera on Mini2440 board to work (OV9650 sensor driver and the board 
file patch) can be found in branch s3c-camif-v3.5 in git repository: 

git://github.com/snawrocki/linux.git 

Gitweb: https://github.com/snawrocki/linux/commits/s3c-camif-v3.5

These patches are based off of stable v3.5 kernel.

The S3C-CAMIF driver exposes one v4l2 subdev and two capture video nodes
- for the "codec" and "preview" data paths. For minimum functionality
there is no need to touch the subdev device node in user space. However it
is recommended for best results.

For my tests I used nice Mini2440 BSP from Pengutronix, which already contains 
various applications, like Gstreamer, v4l2-ctl or even media-ctl. It's 
available at http://www.pengutronix.de/oselas/bsp/pengutronix/index_en.html.

I've tested the driver with mplayer and Gstreamer, also simultaneous capture
from the "preview" and "codec" video nodes. The codec path camera preview at 
framebuffer can be started, for example, with following command:

# gst-launch v4l2src device=/dev/video0 ! video/x-raw-yuv,width=320,height=
  240 ! ffmpegcolorspace ! fbdevsink

In order to select the preview video node (which supports only RGB pixel 
formats) /dev/video0 need to be replaced with /dev/video1, e.g.

# gst-launch v4l2src device=/dev/video1 ! video/x-raw-rgb,bpp=32,endianness=
  4321,depth=32,width=320,height=240 ! ffmpegcolorspace ! fbdevsink

In this case I'm getting slightly incorrect color representation, still need
to figure out why this happens.

The supported pixel formats are listed in the attached 
supported_pixel_formats.txt file.

The camera test pattern is exposed through a private control at the subdev
node, all supported controls are listed in attached supported_controls.txt
file. The test pattern can be enabled e.g. with command:

# v4l2-ctl -d /dev/v4l-subdev1 --set-ctrl=test_pattern=1


A note about the driver's internals

The S3C-CAMIF driver sets at the camera input ("catchcam") (default) pixel 
format as retrieved from the sensor subdev. This happens during driver's 
initialization, so there is no need to touch the subdev in user  space to 
capture video from the camera. If pixel resolution selected at /dev/video? 
differs from the one set at camera input (S3C-CAMIF subdev pad 0), the 
image frames will be resized accordingly, taking into account the resizer's 
capabilities.

To change pixel format at the sensor subdev and the camif input, so those 
better match our target capture resolution, following commands can be used:

media-ctl --set-v4l2 '"OV9650":0 [fmt: YUYV2X8/640x640]'
media-ctl --set-v4l2 '"S3C-CAMIF":0 [fmt: YUYV2X8/640x640]'

The only requirement is that these formats are same, otherwise it won't be
possible to start streaming and VIDIOC_STREAMON will fail wit -EPIPE errno.

The video node numbering might be different, if there are other V4L2
drivers in the system. It can be easily checked with media-ctl utility
(media-ctl -p), my configuration was as in attached camif_media_info.txt
log.

I've run v4l2-compliance on both video nodes, the results can be found in
file v4l2_compliance_log.txt.

A graph depicting device topology can be generated from attached 
camif_graph.dot file (which was created with 'media-ctl --print-dot'), 
with following command: 

# cat camif_graph.dot | dot -Tpdf > camif_graph.pdf
# evince camif_graph.pdf

There is still some more work needed to make the OV9650 sensor driver ready
for the mainline, I'm planning to take care of it in near future. As for 
the CAMIF driver, I might try to push it upstream if it doesn't take too 
much of my time and there is enough interest from the users side.

Feature requests or bug reports are welcome.

Regards,
Sylwester

---


Sylwester Nawrocki (1):
  V4L: Add driver for S3C244X/S3C64XX SoC series camera interface

 drivers/media/video/Kconfig                   |   12 +
 drivers/media/video/Makefile                  |    1 +
 drivers/media/video/s3c-camif/Makefile        |    5 +
 drivers/media/video/s3c-camif/camif-capture.c | 1602 +++++++++++++++++++++
 drivers/media/video/s3c-camif/camif-core.c    |  625 ++++++++
 drivers/media/video/s3c-camif/camif-core.h    |  375 ++++
 drivers/media/video/s3c-camif/camif-regs.c    |  497 ++++++
 drivers/media/video/s3c-camif/camif-regs.h    |  262 ++
 include/media/s3c_camif.h                     |   36 +
 9 files changed, 3415 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s3c-camif/Makefile
 create mode 100644 drivers/media/video/s3c-camif/camif-capture.c
 create mode 100644 drivers/media/video/s3c-camif/camif-core.c
 create mode 100644 drivers/media/video/s3c-camif/camif-core.h
 create mode 100644 drivers/media/video/s3c-camif/camif-regs.c
 create mode 100644 drivers/media/video/s3c-camif/camif-regs.h
 create mode 100644 include/media/s3c_camif.h


--------------080801060203010109090002
Content-Type: application/msword-template;
 name="camif_graph.dot"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="camif_graph.dot"

ZGlncmFwaCBib2FyZCB7CiAgICAgICAgcmFua2Rpcj1UQgogICAgICAgIG4wMDAwMDAwMSBb
bGFiZWw9Int7fSB8IE9WOTY1MFxuL2Rldi92NGwtc3ViZGV2MCB8IHs8cG9ydDA+IDB9fSIs
IHNoYXBlPU1yZWNvcmQsIHN0eWxlPWZpbGxlZCwgZmlsbGNvbG9yPWdyZWVuXQogICAgICAg
IG4wMDAwMDAwMTpwb3J0MCAtPiBuMDAwMDAwMDI6cG9ydDAgW3N0eWxlPWJvbGRdCiAgICAg
ICAgbjAwMDAwMDAyIFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgUzNDLUNBTUlGXG4vZGV2L3Y0
bC1zdWJkZXYxIHwgezxwb3J0MT4gMSB8IDxwb3J0Mj4gMn19Iiwgc2hhcGU9TXJlY29yZCwg
c3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9Z3JlZW5dCiAgICAgICAgbjAwMDAwMDAyOnBvcnQx
IC0+IG4wMDAwMDAwMyBbc3R5bGU9Ym9sZF0KICAgICAgICBuMDAwMDAwMDI6cG9ydDIgLT4g
bjAwMDAwMDA0IFtzdHlsZT1ib2xkXQogICAgICAgIG4wMDAwMDAwMyBbbGFiZWw9ImNhbWlm
LWNvZGVjXG4vZGV2L3ZpZGVvMCIsIHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29s
b3I9eWVsbG93XQogICAgICAgIG4wMDAwMDAwNCBbbGFiZWw9ImNhbWlmLXByZXZpZXdcbi9k
ZXYvdmlkZW8xIiwgc2hhcGU9Ym94LCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj15ZWxsb3dd
Cn0KCg==
--------------080801060203010109090002
Content-Type: text/plain; charset=UTF-8;
 name="v4l2_compliance_log.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="v4l2_compliance_log.txt"

cm9vdEBtaW5pMjQ0MDp+IHY0bDItY29tcGxpYW5jZSAtZCAvZGV2L3ZpZGVvMApEcml2ZXIg
SW5mbzoKICAgICAgICBEcml2ZXIgbmFtZSAgIDogczNjLWNhbWlmCiAgICAgICAgQ2FyZCB0
eXBlICAgICA6IHMzYy1jYW1pZgogICAgICAgIEJ1cyBpbmZvICAgICAgOiBwbGF0Zm9ybQog
ICAgICAgIERyaXZlciB2ZXJzaW9uOiAzLjUuMAogICAgICAgIENhcGFiaWxpdGllcyAgOiAw
eDg0MDAwMDAxCiAgICAgICAgICAgICAgICBWaWRlbyBDYXB0dXJlCiAgICAgICAgICAgICAg
ICBTdHJlYW1pbmcKICAgICAgICAgICAgICAgIERldmljZSBDYXBhYmlsaXRpZXMKICAgICAg
ICBEZXZpY2UgQ2FwcyAgIDogMHgwNDAwMDAwMQogICAgICAgICAgICAgICAgVmlkZW8gQ2Fw
dHVyZQogICAgICAgICAgICAgICAgU3RyZWFtaW5nCgpDb21wbGlhbmNlIHRlc3QgZm9yIGRl
dmljZSAvZGV2L3ZpZGVvMCAobm90IHVzaW5nIGxpYnY0bDIpOgoKUmVxdWlyZWQgaW9jdGxz
OgogICAgICAgIHRlc3QgVklESU9DX1FVRVJZQ0FQOiBPSwoKQWxsb3cgZm9yIG11bHRpcGxl
IG9wZW5zOgogICAgICAgIHRlc3Qgc2Vjb25kIHZpZGVvIG9wZW46IE9LCiAgICAgICAgdGVz
dCBWSURJT0NfUVVFUllDQVA6IE9LCiAgICAgICAgdGVzdCBWSURJT0NfRy9TX1BSSU9SSVRZ
OiBPSwoKRGVidWcgaW9jdGxzOgogICAgICAgIHRlc3QgVklESU9DX0RCR19HX0NISVBfSURF
TlQ6IE5vdCBTdXBwb3J0ZWQKICAgICAgICB0ZXN0IFZJRElPQ19EQkdfRy9TX1JFR0lTVEVS
OiBOb3QgU3VwcG9ydGVkCiAgICAgICAgdGVzdCBWSURJT0NfTE9HX1NUQVRVUzogT0sKCklu
cHV0IGlvY3RsczoKICAgICAgICB0ZXN0IFZJRElPQ19HL1NfVFVORVI6IE5vdCBTdXBwb3J0
ZWQKICAgICAgICB0ZXN0IFZJRElPQ19HL1NfRlJFUVVFTkNZOiBOb3QgU3VwcG9ydGVkCiAg
ICAgICAgdGVzdCBWSURJT0NfU19IV19GUkVRX1NFRUs6IE5vdCBTdXBwb3J0ZWQKICAgICAg
ICB0ZXN0IFZJRElPQ19FTlVNQVVESU86IE5vdCBTdXBwb3J0ZWQKICAgICAgICB0ZXN0IFZJ
RElPQ19HL1MvRU5VTUlOUFVUOiBPSwogICAgICAgIHRlc3QgVklESU9DX0cvU19BVURJTzog
Tm90IFN1cHBvcnRlZAogICAgICAgIElucHV0czogMSBBdWRpbyBJbnB1dHM6IDAgVHVuZXJz
OiAwCgpPdXRwdXQgaW9jdGxzOgogICAgICAgIHRlc3QgVklESU9DX0cvU19NT0RVTEFUT1I6
IE5vdCBTdXBwb3J0ZWQKICAgICAgICB0ZXN0IFZJRElPQ19HL1NfRlJFUVVFTkNZOiBOb3Qg
U3VwcG9ydGVkCiAgICAgICAgdGVzdCBWSURJT0NfRU5VTUFVRE9VVDogTm90IFN1cHBvcnRl
ZAogICAgICAgIHRlc3QgVklESU9DX0cvUy9FTlVNT1VUUFVUOiBOb3QgU3VwcG9ydGVkCiAg
ICAgICAgdGVzdCBWSURJT0NfRy9TX0FVRE9VVDogTm90IFN1cHBvcnRlZAogICAgICAgIE91
dHB1dHM6IDAgQXVkaW8gT3V0cHV0czogMCBNb2R1bGF0b3JzOiAwCgpDb250cm9sIGlvY3Rs
czoKICAgICAgICB0ZXN0IFZJRElPQ19RVUVSWUNUUkwvTUVOVTogT0sKICAgICAgICB0ZXN0
IFZJRElPQ19HL1NfQ1RSTDogT0sKICAgICAgICB0ZXN0IFZJRElPQ19HL1MvVFJZX0VYVF9D
VFJMUzogT0sKICAgICAgICB0ZXN0IFZJRElPQ18oVU4pU1VCU0NSSUJFX0VWRU5UL0RRRVZF
TlQ6IE9LCiAgICAgICAgdGVzdCBWSURJT0NfRy9TX0pQRUdDT01QOiBOb3QgU3VwcG9ydGVk
CiAgICAgICAgU3RhbmRhcmQgQ29udHJvbHM6IDMgUHJpdmF0ZSBDb250cm9sczogMAoKSW5w
dXQvT3V0cHV0IGNvbmZpZ3VyYXRpb24gaW9jdGxzOgogICAgICAgIHRlc3QgVklESU9DX0VO
VU0vRy9TL1FVRVJZX1NURDogTm90IFN1cHBvcnRlZAogICAgICAgIHRlc3QgVklESU9DX0VO
VU0vRy9TL1FVRVJZX0RWX1BSRVNFVFM6IE5vdCBTdXBwb3J0ZWQKICAgICAgICB0ZXN0IFZJ
RElPQ19FTlVNL0cvUy9RVUVSWV9EVl9USU1JTkdTOiBOb3QgU3VwcG9ydGVkCiAgICAgICAg
dGVzdCBWSURJT0NfRFZfVElNSU5HU19DQVA6IE5vdCBTdXBwb3J0ZWQKCkZvcm1hdCBpb2N0
bHM6CiAgICAgICAgdGVzdCBWSURJT0NfRU5VTV9GTVQvRlJBTUVTSVpFUy9GUkFNRUlOVEVS
VkFMUzogT0sKICAgICAgICAgICAgICAgIGZhaWw6IHY0bDItdGVzdC1mb3JtYXRzLmNwcCg1
NTgpOiBjYXAtPnJlYWRidWZmZXJzCiAgICAgICAgdGVzdCBWSURJT0NfRy9TX1BBUk06IEZB
SUwKICAgICAgICB0ZXN0IFZJRElPQ19HX0ZCVUY6IE5vdCBTdXBwb3J0ZWQKICAgICAgICB0
ZXN0IFZJRElPQ19HX0ZNVDogT0sKICAgICAgICB0ZXN0IFZJRElPQ19HX1NMSUNFRF9WQklf
Q0FQOiBOb3QgU3VwcG9ydGVkCkJ1ZmZlciBpb2N0bHM6CiAgICAgICAgdGVzdCBWSURJT0Nf
UkVRQlVGUy9DUkVBVEVfQlVGUzogT0sKICAgICAgICB0ZXN0IHJlYWQvd3JpdGU6IE9LClRv
dGFsOiAzNCwgU3VjY2VlZGVkOiAzMywgRmFpbGVkOiAxLCBXYXJuaW5nczogMAoKCnJvb3RA
bWluaTI0NDA6fiB2NGwyLWNvbXBsaWFuY2UgLWQgL2Rldi92aWRlbzEKRHJpdmVyIEluZm86
CiAgICAgICAgRHJpdmVyIG5hbWUgICA6IHMzYy1jYW1pZgogICAgICAgIENhcmQgdHlwZSAg
ICAgOiBzM2MtY2FtaWYKICAgICAgICBCdXMgaW5mbyAgICAgIDogcGxhdGZvcm0KICAgICAg
ICBEcml2ZXIgdmVyc2lvbjogMy41LjAKICAgICAgICBDYXBhYmlsaXRpZXMgIDogMHg4NDAw
MDAwMQogICAgICAgICAgICAgICAgVmlkZW8gQ2FwdHVyZQogICAgICAgICAgICAgICAgU3Ry
ZWFtaW5nCiAgICAgICAgICAgICAgICBEZXZpY2UgQ2FwYWJpbGl0aWVzCiAgICAgICAgRGV2
aWNlIENhcHMgICA6IDB4MDQwMDAwMDEKICAgICAgICAgICAgICAgIFZpZGVvIENhcHR1cmUK
ICAgICAgICAgICAgICAgIFN0cmVhbWluZwoKQ29tcGxpYW5jZSB0ZXN0IGZvciBkZXZpY2Ug
L2Rldi92aWRlbzEgKG5vdCB1c2luZyBsaWJ2NGwyKToKClJlcXVpcmVkIGlvY3RsczoKICAg
ICAgICB0ZXN0IFZJRElPQ19RVUVSWUNBUDogT0sKCkFsbG93IGZvciBtdWx0aXBsZSBvcGVu
czoKICAgICAgICB0ZXN0IHNlY29uZCB2aWRlbyBvcGVuOiBPSwogICAgICAgIHRlc3QgVklE
SU9DX1FVRVJZQ0FQOiBPSwogICAgICAgIHRlc3QgVklESU9DX0cvU19QUklPUklUWTogT0sK
CkRlYnVnIGlvY3RsczoKICAgICAgICB0ZXN0IFZJRElPQ19EQkdfR19DSElQX0lERU5UOiBO
b3QgU3VwcG9ydGVkCiAgICAgICAgdGVzdCBWSURJT0NfREJHX0cvU19SRUdJU1RFUjogTm90
IFN1cHBvcnRlZAogICAgICAgIHRlc3QgVklESU9DX0xPR19TVEFUVVM6IE9LCgpJbnB1dCBp
b2N0bHM6CiAgICAgICAgdGVzdCBWSURJT0NfRy9TX1RVTkVSOiBOb3QgU3VwcG9ydGVkCiAg
ICAgICAgdGVzdCBWSURJT0NfRy9TX0ZSRVFVRU5DWTogTm90IFN1cHBvcnRlZAogICAgICAg
IHRlc3QgVklESU9DX1NfSFdfRlJFUV9TRUVLOiBOb3QgU3VwcG9ydGVkCiAgICAgICAgdGVz
dCBWSURJT0NfRU5VTUFVRElPOiBOb3QgU3VwcG9ydGVkCiAgICAgICAgdGVzdCBWSURJT0Nf
Ry9TL0VOVU1JTlBVVDogT0sKICAgICAgICB0ZXN0IFZJRElPQ19HL1NfQVVESU86IE5vdCBT
dXBwb3J0ZWQKICAgICAgICBJbnB1dHM6IDEgQXVkaW8gSW5wdXRzOiAwIFR1bmVyczogMAoK
T3V0cHV0IGlvY3RsczoKICAgICAgICB0ZXN0IFZJRElPQ19HL1NfTU9EVUxBVE9SOiBOb3Qg
U3VwcG9ydGVkCiAgICAgICAgdGVzdCBWSURJT0NfRy9TX0ZSRVFVRU5DWTogTm90IFN1cHBv
cnRlZAogICAgICAgIHRlc3QgVklESU9DX0VOVU1BVURPVVQ6IE5vdCBTdXBwb3J0ZWQKICAg
ICAgICB0ZXN0IFZJRElPQ19HL1MvRU5VTU9VVFBVVDogTm90IFN1cHBvcnRlZAogICAgICAg
IHRlc3QgVklESU9DX0cvU19BVURPVVQ6IE5vdCBTdXBwb3J0ZWQKICAgICAgICBPdXRwdXRz
OiAwIEF1ZGlvIE91dHB1dHM6IDAgTW9kdWxhdG9yczogMAoKQ29udHJvbCBpb2N0bHM6CiAg
ICAgICAgdGVzdCBWSURJT0NfUVVFUllDVFJML01FTlU6IE9LCiAgICAgICAgdGVzdCBWSURJ
T0NfRy9TX0NUUkw6IE9LCiAgICAgICAgdGVzdCBWSURJT0NfRy9TL1RSWV9FWFRfQ1RSTFM6
IE9LCiAgICAgICAgdGVzdCBWSURJT0NfKFVOKVNVQlNDUklCRV9FVkVOVC9EUUVWRU5UOiBP
SwogICAgICAgIHRlc3QgVklESU9DX0cvU19KUEVHQ09NUDogTm90IFN1cHBvcnRlZAogICAg
ICAgIFN0YW5kYXJkIENvbnRyb2xzOiAzIFByaXZhdGUgQ29udHJvbHM6IDAKCklucHV0L091
dHB1dCBjb25maWd1cmF0aW9uIGlvY3RsczoKICAgICAgICB0ZXN0IFZJRElPQ19FTlVNL0cv
Uy9RVUVSWV9TVEQ6IE5vdCBTdXBwb3J0ZWQKICAgICAgICB0ZXN0IFZJRElPQ19FTlVNL0cv
Uy9RVUVSWV9EVl9QUkVTRVRTOiBOb3QgU3VwcG9ydGVkCiAgICAgICAgdGVzdCBWSURJT0Nf
RU5VTS9HL1MvUVVFUllfRFZfVElNSU5HUzogTm90IFN1cHBvcnRlZAogICAgICAgIHRlc3Qg
VklESU9DX0RWX1RJTUlOR1NfQ0FQOiBOb3QgU3VwcG9ydGVkCgpGb3JtYXQgaW9jdGxzOgog
ICAgICAgIHRlc3QgVklESU9DX0VOVU1fRk1UL0ZSQU1FU0laRVMvRlJBTUVJTlRFUlZBTFM6
IE9LCiAgICAgICAgICAgICAgICBmYWlsOiB2NGwyLXRlc3QtZm9ybWF0cy5jcHAoNTU4KTog
Y2FwLT5yZWFkYnVmZmVycwogICAgICAgIHRlc3QgVklESU9DX0cvU19QQVJNOiBGQUlMCiAg
ICAgICAgdGVzdCBWSURJT0NfR19GQlVGOiBOb3QgU3VwcG9ydGVkCiAgICAgICAgdGVzdCBW
SURJT0NfR19GTVQ6IE9LCiAgICAgICAgdGVzdCBWSURJT0NfR19TTElDRURfVkJJX0NBUDog
Tm90IFN1cHBvcnRlZApCdWZmZXIgaW9jdGxzOgogICAgICAgIHRlc3QgVklESU9DX1JFUUJV
RlMvQ1JFQVRFX0JVRlM6IE9LCiAgICAgICAgdGVzdCByZWFkL3dyaXRlOiBPSwpUb3RhbDog
MzQsIFN1Y2NlZWRlZDogMzMsIEZhaWxlZDogMSwgV2FybmluZ3M6IDAKCgo=
--------------080801060203010109090002
Content-Type: text/plain; charset=UTF-8;
 name="camif_media_info.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="camif_media_info.txt"

cm9vdEBtaW5pMjQ0MDp+IG1lZGlhLWN0bCAtcApPcGVuaW5nIG1lZGlhIGRldmljZSAvZGV2
L21lZGlhMApFbnVtZXJhdGluZyBlbnRpdGllcwpGb3VuZCA0IGVudGl0aWVzCkVudW1lcmF0
aW5nIHBhZHMgYW5kIGxpbmtzCk1lZGlhIGNvbnRyb2xsZXIgQVBJIHZlcnNpb24gMC4wLjAK
Ck1lZGlhIGRldmljZSBpbmZvcm1hdGlvbgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KZHJp
dmVyICAgICAgICAgIHMzYy1jYW1pZgptb2RlbCAgICAgICAgICAgU0FNU1VORyBTM0MyNDRY
IENBTUlGCnNlcmlhbCAgICAgICAgICAKYnVzIGluZm8gICAgICAgIHBsYXRmb3JtCmh3IHJl
dmlzaW9uICAgICAweDIwCmRyaXZlciB2ZXJzaW9uICAxLjAuMAoKRGV2aWNlIHRvcG9sb2d5
Ci0gZW50aXR5IDE6IE9WOTY1MCAoMSBwYWQsIDEgbGluaykKICAgICAgICAgICAgdHlwZSBW
NEwyIHN1YmRldiBzdWJ0eXBlIFNlbnNvcgogICAgICAgICAgICBkZXZpY2Ugbm9kZSBuYW1l
IC9kZXYvdjRsLXN1YmRldjAKICAgICAgICBwYWQwOiBTb3VyY2UKICAgICAgICAgICAgICAg
IFtmbXQ6WVVZVjJYOC82NDB4NDgwXQogICAgICAgICAgICAgICAgLT4gIlMzQy1DQU1JRiI6
MCBbRU5BQkxFRCxJTU1VVEFCTEVdCgotIGVudGl0eSAyOiBTM0MtQ0FNSUYgKDMgcGFkcywg
MyBsaW5rcykKICAgICAgICAgICAgdHlwZSBWNEwyIHN1YmRldiBzdWJ0eXBlIFVua25vd24K
ICAgICAgICAgICAgZGV2aWNlIG5vZGUgbmFtZSAvZGV2L3Y0bC1zdWJkZXYxCiAgICAgICAg
cGFkMDogU2luawogICAgICAgICAgICAgICAgW2ZtdDpZVVlWMlg4LzY0MHg0ODAKICAgICAg
ICAgICAgICAgICBjcm9wLmJvdW5kczooMCwwKS82NDB4NDgwCiAgICAgICAgICAgICAgICAg
Y3JvcDooMCwwKS82NDB4NDgwXQogICAgICAgICAgICAgICAgPC0gIk9WOTY1MCI6MCBbRU5B
QkxFRCxJTU1VVEFCTEVdCiAgICAgICAgcGFkMTogU291cmNlCiAgICAgICAgICAgICAgICBb
Zm10OllVWVYyWDgvNjQweDQ4MF0KICAgICAgICAgICAgICAgIC0+ICJjYW1pZi1jb2RlYyI6
MCBbRU5BQkxFRCxJTU1VVEFCTEVdCiAgICAgICAgcGFkMjogU291cmNlCiAgICAgICAgICAg
ICAgICBbZm10OllVWVYyWDgvNjQweDQ4MF0KICAgICAgICAgICAgICAgIC0+ICJjYW1pZi1w
cmV2aWV3IjowIFtFTkFCTEVELElNTVVUQUJMRV0KCi0gZW50aXR5IDM6IGNhbWlmLWNvZGVj
ICgxIHBhZCwgMSBsaW5rKQogICAgICAgICAgICB0eXBlIE5vZGUgc3VidHlwZSBWNEwKICAg
ICAgICAgICAgZGV2aWNlIG5vZGUgbmFtZSAvZGV2L3ZpZGVvMAogICAgICAgIHBhZDA6IFNp
bmsKICAgICAgICAgICAgICAgIDwtICJTM0MtQ0FNSUYiOjEgW0VOQUJMRUQsSU1NVVRBQkxF
XQoKLSBlbnRpdHkgNDogY2FtaWYtcHJldmlldyAoMSBwYWQsIDEgbGluaykKICAgICAgICAg
ICAgdHlwZSBOb2RlIHN1YnR5cGUgVjRMCiAgICAgICAgICAgIGRldmljZSBub2RlIG5hbWUg
L2Rldi92aWRlbzEKICAgICAgICBwYWQwOiBTaW5rCiAgICAgICAgICAgICAgICA8LSAiUzND
LUNBTUlGIjoyIFtFTkFCTEVELElNTVVUQUJMRV0KCg==
--------------080801060203010109090002
Content-Type: text/plain; charset=UTF-8;
 name="supported_pixel_formats.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="supported_pixel_formats.txt"

cm9vdEBtaW5pMjQ0MDp+IHY0bDItY3RsIC1kIC9kZXYvdmlkZW8wIC0tbGlzdC1mb3JtYXRz
CmlvY3RsOiBWSURJT0NfRU5VTV9GTVQKICAgICAgICBJbmRleCAgICAgICA6IDAKICAgICAg
ICBUeXBlICAgICAgICA6IFZpZGVvIENhcHR1cmUKICAgICAgICBQaXhlbCBGb3JtYXQ6ICc0
MjJQJwogICAgICAgIE5hbWUgICAgICAgIDogWVVWIDQ6MjoyIHBsYW5hciwgWS9DYi9DcgoK
ICAgICAgICBJbmRleCAgICAgICA6IDEKICAgICAgICBUeXBlICAgICAgICA6IFZpZGVvIENh
cHR1cmUKICAgICAgICBQaXhlbCBGb3JtYXQ6ICdZVTEyJwogICAgICAgIE5hbWUgICAgICAg
IDogWVVWIDQ6MjowIHBsYW5hciwgWS9DYi9DcgoKcm9vdEBtaW5pMjQ0MDp+IApyb290QG1p
bmkyNDQwOn4gCnJvb3RAbWluaTI0NDA6fiAKcm9vdEBtaW5pMjQ0MDp+IApyb290QG1pbmky
NDQwOn4gCnJvb3RAbWluaTI0NDA6fiB2NGwyLWN0bCAtZCAvZGV2L3ZpZGVvMSAtLWxpc3Qt
Zm9ybWF0cwppb2N0bDogVklESU9DX0VOVU1fRk1UCiAgICAgICAgSW5kZXggICAgICAgOiAw
CiAgICAgICAgVHlwZSAgICAgICAgOiBWaWRlbyBDYXB0dXJlCiAgICAgICAgUGl4ZWwgRm9y
bWF0OiAnUkdCUicKICAgICAgICBOYW1lICAgICAgICA6IFJHQjU2NSwgMTYgYnBwCgogICAg
ICAgIEluZGV4ICAgICAgIDogMQogICAgICAgIFR5cGUgICAgICAgIDogVmlkZW8gQ2FwdHVy
ZQogICAgICAgIFBpeGVsIEZvcm1hdDogJ1JHQjQnCiAgICAgICAgTmFtZSAgICAgICAgOiBY
UkdCODg4OCwgMzIgYnBwCgo=
--------------080801060203010109090002
Content-Type: text/plain; charset=UTF-8;
 name="supported_controls.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="supported_controls.txt"

cm9vdEBtaW5pMjQ0MDp+IHY0bDItY3RsIC1kIC9kZXYvdmlkZW8wIC0tbGlzdC1jdHJscwoK
VXNlciBDb250cm9scwoKICAgICAgICAgICAgICAgIGhvcml6b250YWxfZmxpcCAoYm9vbCkg
ICA6IGRlZmF1bHQ9MCB2YWx1ZT0wCiAgICAgICAgICAgICAgICAgIHZlcnRpY2FsX2ZsaXAg
KGJvb2wpICAgOiBkZWZhdWx0PTAgdmFsdWU9MAoKcm9vdEBtaW5pMjQ0MDp+IHY0bDItY3Rs
IC1kIC9kZXYvdmlkZW8xIC0tbGlzdC1jdHJscwoKVXNlciBDb250cm9scwoKICAgICAgICAg
ICAgICAgIGhvcml6b250YWxfZmxpcCAoYm9vbCkgICA6IGRlZmF1bHQ9MCB2YWx1ZT0wCiAg
ICAgICAgICAgICAgICAgIHZlcnRpY2FsX2ZsaXAgKGJvb2wpICAgOiBkZWZhdWx0PTAgdmFs
dWU9MAoKcm9vdEBtaW5pMjQ0MDp+IHY0bDItY3RsIC1kIC9kZXYvdjRsLXN1YmRldjEgLS1s
aXN0LWN0cmxzClZJRElPQ19RVUVSWUNBUDogZmFpbGVkOiBJbmFwcHJvcHJpYXRlIGlvY3Rs
IGZvciBkZXZpY2UKClVzZXIgQ29udHJvbHMKCiAgICAgICAgICAgICAgICAgICB0ZXN0X3Bh
dHRlcm4gKGludCkgICAgOiBtaW49MCBtYXg9MyBzdGVwPTEgZGVmYXVsdD0wIHZhbHVlPTAK
Cg==
--------------080801060203010109090002--
