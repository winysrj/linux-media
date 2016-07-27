Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:56815 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324AbcG0Jx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2016 05:53:26 -0400
Subject: Re: [GIT PULL for v4.8-rc1] media updates part II: documentation
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20160727062313.375a5cad@recife.lan>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d3a51c25-fe71-46b1-1274-d24da9f8d3c5@xs4all.nl>
Date: Wed, 27 Jul 2016 11:53:16 +0200
MIME-Version: 1.0
In-Reply-To: <20160727062313.375a5cad@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Linus,

On 07/27/2016 11:23 AM, Mauro Carvalho Chehab wrote:
> Hi Linus,
> 
> Please pull from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.8-4
> 
> For media documentation updates.
> 
> This patch series does the conversion of all media documentation stuff
> to Restrutured Text markup format and add them to the Documentation/index.rst
> file. The media documentation was grouped into 4 books:
> 	- media uAPI;
> 	- media kAPI;
> 	- V4L driver-specific documentation;
> 	- DVB driver-specific documentation.
> 
> It also contains several documentation improvements and one fixup patch for
> a core issue with cropcap.

FYI: the cropcap fixup patch (v4l2-ioctl: fix stupid mistake in cropcap condition)
is already upstream (it got merged just before 4.7 was released).

So that patch can be dropped.

Regards,

	Hans

> 
> PS.: After this patch series, the media DocBook is deprecated and should
> be removed. I'll add such patch on a future pull request.
> 
> Thanks!
> Mauro
> 
> The following changes since commit 9c1958fc326a0a0a533ec8e86ea6fa30977207de:
> 
>   Merge tag 'media/v4.8-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2016-07-26 18:59:59 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.8-4
> 
> for you to fetch changes up to 9701e696fedbb70a26ecc1c28ece6a2c8e9f220c:
> 
>   Merge branch 'topic/docs-next' into v4l_for_linus (2016-07-27 06:12:29 -0300)
> 
> ----------------------------------------------------------------
> media updates for v4.8-rc1
> 
> ----------------------------------------------------------------
> Hans Verkuil (6):
>       [media] pixfmt-006.rst: add missing V4L2_YCBCR_ENC_SMPTE240M
>       [media] vidioc-g-dv-timings.rst: document interlaced defines
>       [media] doc-rst: update CEC_RECEIVE
>       [media] doc-rst: improve CEC documentation
>       [media] doc-rst: cec: update documentation
>       [media] v4l2-ioctl: fix stupid mistake in cropcap condition
> 
> Markus Heiser (10):
>       doc-rst: linux_tv DocBook to reST migration (docs-next)
>       doc-rst: boilerplate HTML theme customization
>       doc-rst: customize RTD theme, table & full width
>       doc-rst: customize RTD theme, captions & inline literal
>       doc-rst: auto-generate: fixed include "output/*.h.rst" content
>       doc-rst: add kernel-include directive
>       doc-rst: linux_tv/Makefile: Honor quiet make O=dir
>       [media] doc-rst: linux_tv CEC part, DocBook to reST migration
>       [media] doc-rst: linux_tc CEC enhanced markup
>       [media] doc-rst: media: reordered top sectioning
> 
> Mauro Carvalho Chehab (314):
>       Merge branch 'docs-next' of git://git.lwn.net/linux into devel/docs-next
>       doc-rst: linuxt_tv: update the documentation year
>       doc-rst: some fixups at linux_tv/index
>       doc-rst: v4l2: Fix authors and revisions lists
>       doc-rst: querycap: fix troubles on some references
>       doc-rst: linux_tv/index: add xrefs for document divisions
>       doc-rst: app-pri: Fix a bad reference
>       doc-rst: video: use reference for VIDIOC_ENUMINPUT
>       doc-rst: v4l2: numerate the V4L2 chapters
>       doc-rst: video: Restore the captions for the examples
>       doc-rst: audio: Fix some cross references
>       doc-rst: linux_tv: Replace reference names to match ioctls
>       doc-rst: linux_tv: simplify references
>       doc-rst: linux_tv: convert lots of consts to references
>       doc-rst: linux_tv: don't simplify VIDIOC_G_foo references
>       doc-rst: audio: re-add captions for the examples
>       doc-rst: standard: read the example captions
>       doc-rst: linux_tv: remove controls
>       doc-rst: control: read the example captions
>       doc-rst: control: Fix missing reference for example 8
>       doc-rst: extended-controls: use reference for VIDIOC_S_CTRL
>       doc-rst: vidioc-queryctl: change the title of this chapter
>       doc-rst: linux_tv: supress lots of warnings
>       doc-rst: planar-apis: fix some conversion troubles
>       doc-rst: crop: fix conversion on this file
>       doc-rst: selection-api-005: Fix ReST parsing
>       doc-rst: linux_tv: use Example x.y. instead of a single number
>       doc-rst: selection-api-006: add missing captions
>       doc-rst: linux_tv: Error codes should be const
>       doc-rst: linux_tv: use references for structures
>       doc-rst: linux_tv: Fix remaining undefined references
>       doc-rst: pixfmt-007: Fix formula parsing
>       doc-rst: fdl-appendix: Fix formatting issues
>       doc-rst: linux_tv: fix some warnings due to '*'
>       doc-rst: fe_property_parameters: improve descriptions
>       doc-rst: vidioc-g-edid remove a duplicate declaration
>       doc-rst: open: fix some warnings
>       doc-rst: rw fix a warning
>       doc-rst: extended-controls: "count" is a constant
>       doc-rst: pixfmt-004: Add an extra reference
>       doc-rst: linux_tv: remove trailing comments
>       doc-rst: pixfmt-y12i: correct format conversion
>       doc-rst: pixfmt-uyvy: remove an empty column
>       doc-rst: pixfmt-yvyu: remove an empty column
>       doc-rst: pixfmt-vyuy: remove an empty column
>       doc-rst: pixfmt-41p: remove empty columns
>       doc-rst: pixfmt-yuv422m: remove an empty column
>       doc-rst: pixfmt-yuv444m: remove empty columns
>       doc-rst: pixfmt-yuv422p: remove an empty column
>       doc-rst: pixfmt-yuv411p: remove an empty column
>       doc-rst: pixfmt-nv12: remove empty columns
>       doc-rst: pixfmt-nv12m: fix conversion issues
>       doc-rst: linux_tv: Fix some occurences of :sub:
>       doc-rst: pixfmt-nv16: remove an empty column
>       doc-rst: dmx_fcalls: improve man-like format
>       doc-rst: video_function_calls: improve man-like format
>       doc-rst: ca_function_calls: improve man-like format
>       doc-rst: audio_function_calls: improve man-like format
>       doc-rst: FE_SET_FRONTEND: improve man-like format
>       doc-rst: FE_READ_UNCORRECTED_BLOCKS: improve man-like format
>       doc-rst: FE_READ_SNR: improve man-like format
>       doc-rst: FE_READ_SIGNAL_STRENGTH: improve man-like format
>       doc-rst: FE_READ_BER: improve man-like format
>       doc-rst: FE_GET_FRONTEND: improve man-like format
>       doc-rst: FE_GET_EVENT: improve man-like format
>       doc-rst: FE_DISHNETWORK_SEND_LEGACY_CMD: improve man-like format
>       doc-rst: linux_tv: fix remaining lack of escapes
>       doc-rst: linux_tv: avoid using c:func::
>       doc-rst: linux_tv: move RC stuff to a separate dir
>       doc-rst: linux_tv: move MC stuff to a separate dir
>       doc-rst: linux_tv: promote generic documents to the parent dir
>       doc-rst: linux_tv: Fix a warning at lirc_dev_intro
>       doc-rst: pixfmt-nv16m: remove an empty column
>       doc-rst: v4l/pixfmt: re-join a broken paragraph
>       doc-rst: pixfmt-nv16m: remove an empty column
>       doc-rst: mmap: re-add the missing captions
>       doc-rst: mmap: Add ioctl cross references
>       doc-rst: userp: re-add the missing captions
>       doc-rst: userp: Add ioctl cross references
>       doc-rst: linux_tv: remove whitespaces
>       doc-rst: dmabuf: re-add the missing captions
>       doc-rst: dmabuf: Add ioctl cross references
>       doc-rst: buffer: numerate tables
>       doc-rst: buffer: numerate tables and figures
>       doc-rst: dev-overlay: Fix conversion issues
>       doc-rst: dev-osd: Fix some issues due to conversion
>       doc-rst: dev-codec: Fix a reference for _STREAMON
>       doc-rst: linux_tv: Use references for read()/write()
>       doc-rst: dev-raw-vbi fix conversion issues
>       doc-rst: dev-sliced-vbi: convert table captions into headers
>       doc-rst: dev-subdev: fix some format issues
>       doc-rst: subdev-formats: Improve figure caption
>       doc-rst: libv4l-introduction: improve format
>       doc-rst: linux_tv: split DVB function call documentation
>       doc-rst: linux_tv: reformat all syscall pages
>       doc-rst: linux_tv: dvb: use lowercase for filenames
>       doc-rst: linux_tv: dvb: put return value at the end
>       doc-rst: remove Documentation/linux_tv/conf.py file
>       doc-rst: linux_tv: don't use uppercases for syscall sections
>       doc-rst: linux_tv: use :cpp:function:: on all syscalls
>       doc-rst: dmabuf: Fix the cross-reference
>       doc-rst: dev-overlay: fix the last warning
>       doc-rst: dvbapi: Fix conversion issues
>       doc-rst: fix intro_files/dvbstb.png image
>       doc-rst: dvb/intro: Better show the needed include blocks
>       doc-rst: intro: remove obsolete headers
>       doc-rst: media-controller: fix conversion issues
>       doc-rst: media-controller: missing credits
>       doc-rst: media-controller.rst: add missing copy symbol
>       doc-rst: media-controller-model: fix a typo
>       doc-rst: mediactl: fix some wrong cross references
>       doc-rst: media-ioc-g-topology: Fix tables
>       doc-rst: media-ioc-enum-entities: better format the table
>       doc-rst: gen-errors: Improve table layout
>       doc-rst: remote_controllers: fix conversion issues
>       doc-rst: Rename the title of the Digital TV section
>       doc-rst: v4l2: Rename the V4L2 API title
>       doc-rst: linux_tv/index: Rename the book name
>       doc-rst: add parse-headers.pl script
>       doc-rst: auto-build the frontend.h.rst
>       doc-rst: parse-headers: improve delimiters to detect symbols
>       doc-dst: parse-headers: highlight deprecated comments
>       doc-rst: fix parsing comments and '{' on a separate line
>       doc-rst: parse-headers: be more formal about the valid symbols
>       doc-rst: parse-headers: better handle typedefs
>       doc-rst: parse-headers: fix multiline typedef handler
>       doc-rst: auto-generate dmx.h.rst
>       doc-rst: auto-generate audio.h.rst
>       doc-rst: auto-generate ca.h.rst
>       doc-rst: auto-generate net.h.rst
>       doc-rst: auto-generate video.h.rst
>       doc-rst: parse-headers: better handle comments at the source code
>       doc-rst: parse-headers: add an option to ignore enum symbols
>       doc-rst: parse-headers: don't do substituition references
>       doc-rst: autogenerate videodev2.h.rst file
>       doc-rst: fix some badly converted references
>       doc-rst: linux_tv: Don't ignore pix formats
>       doc-rst: videodev2.h: don't ignore V4L2_STD macros
>       doc-rst: document enum symbols
>       doc-rst: videodev2.h: add cross-references for defines
>       doc-rst: linux_tv/Makefile: Honor quiet mode
>       doc-rst: remove an invalid include from the docs
>       doc_rst: rename the media Sphinx suff to Documentation/media
>       [media] doc-rst: add dmabuf as streaming I/O in VIDIOC_REQBUFS description
>       [media] doc-rst: mention the memory type to be set for all streaming I/O
>       [media] doc-rst: fix the Z16 format definition
>       [media] doc-dst: visually improve the CEC pages
>       [media] doc-rst: reformat cec-api.rst
>       [media] doc-rst: Add new types to media-types.rst
>       doc-rst: parse-headers: remove trailing spaces
>       [media] doc-rst: add media.h header to media contrller
>       Merge branch 'topic/cec' into topic/docs-next
>       [media] doc-rst: add CEC header file to the documentation
>       [media] doc-rst: make CEC look more like other parts of the book
>       [media] doc-rst: Group function references together for MC
>       [media] doc-rst: remove an extra label on V4L2 and CEC parts
>       [media] doc-rst: rename some RC files
>       [media] doc-rst: improve LIRC syscall documentation
>       [media] doc-rst: add LIRC header to the book
>       [media] doc-rst: do cross-references between header and the doc
>       [media] doc-rst: Don't use captions for examples
>       [media] doc-rst: improve documentation for DTV_FREQUENCY
>       [media] doc-rst: improve DTV_BANDWIDTH_HZ notes
>       [media] doc-rst: improve display of notes and warnings
>       [media] doc-rst: Document ioctl LIRC_GET_FEATURES
>       [media] doc-rst: add media/uapi/rc/lirc-header.rst
>       [media] lirc.h: remove several unused ioctls
>       [media] doc-rst: remove not used ioctls from documentation
>       [media] doc-rst: Fix LIRC_GET_FEATURES references
>       [media] doc-rst: document ioctl LIRC_GET_SEND_MODE
>       [media] doc-rst: fix some lirc cross-references
>       [media] doc-rst: document ioctl LIRC_GET_REC_MODE
>       [media] doc-rst: document LIRC_GET_REC_RESOLUTION
>       [media] doc-rst: document LIRC_SET_SEND_DUTY_CYCLE
>       [media] doc-rst: document LIRC_GET_*_TIMEOUT ioctls
>       [media] doc-rst: document LIRC_GET_LENGTH ioctl
>       [media] doc-rst: document LIRC set carrier ioctls
>       [media] doc-rst: document LIRC_SET_TRANSMITTER_MASK
>       [media] doc-rst: document LIRC_SET_REC_TIMEOUT
>       [media] doc-rst: document LIRC_SET_REC_TIMEOUT_REPORTS
>       [media] doc-rst: add documentation for LIRC_SET_MEASURE_CARRIER_MODE
>       [media] doc-rst: document LIRC_SET_WIDEBAND_RECEIVER
>       [media] doc-rst: document LIRC set mode ioctls
>       [media] doc-rst: reorganize LIRC ReST files
>       [media] doc-rst: fix a missing reference for V4L2_BUF_FLAG_LAST
>       [media] doc-rst: use the right markup for footnotes
>       [media] docs-rst: escape [] characters
>       Revert "[media] docs-rst: escape [] characters"
>       [media] doc-rst: fix htmldocs build warnings
>       [media] doc-rst: fix an undefined reference
>       [media] doc-rst: increase depth of the main index
>       [media] docs-rst: Fix some typos
>       Merge branch 'docs-next' of git://git.lwn.net/linux into devel/docs-next
>       doc-rst: Fix compilation of the pdf docbook
>       [media] doc-rst: Convert media API to rst
>       [media] doc-rst: media_drivers.rst: Fix paragraph headers for MC
>       [media] doc-rst: split media_drivers.rst into one file per API type
>       [media] doc-rst: Fix issues with RC documentation
>       [media] doc-rst: Fix conversion for v4l2 core functions
>       [media] doc-rst: Fix conversion for MC core functions
>       [media] doc-rst: Fix conversion for dvb-core.rst
>       [media] doc-rst: move DVB avulse docs to Documentation/media
>       [media] doc-rst: move DVB introduction to a separate file
>       [media] doc-rst: Fix format of avermedia.rst
>       [media] doc-rst: convert bt8xx doc to rst
>       [media] doc-rst: convert cards to rst format
>       [media] doc-rst: Convert ci.txt to a rst file
>       [media] doc-rst: Convert contributors list to ReST
>       [media] doc-rst: Convert dvb-usb to ReST format
>       [media] doc-rst: convert DVB FAQ to ReST format
>       [media] doc-rst: Convert lmedm04 to rst format
>       [media] doc-rst: add opera-firmware.rst to DVB docs
>       [media] doc-rst: Convert technisat document to ReST
>       [media] doc-rst: convert ttusb-dev to rst
>       [media] doc-rst: convert udev chapter to rst
>       [media] add DVB documentation to Sphinx
>       [media] extract_xc3028.pl: move it to scripts/dir
>       [media] doc-rst: move cardlists to media/v4l-drivers
>       [media] doc-rst: Remove deprecated API.html document
>       [media] doc-rst: move framework docs to kAPI documentation
>       [media] doc-rst: do a poor man's conversion of v4l2-framework
>       [media] doc-rst: move videobuf documentation to media/kapi
>       [media] doc-rst: Convert videobuf documentation to ReST
>       doc-rst: add v4l-drivers to index file
>       [media] doc-rst: Move v4l docs to media/v4l-drivers
>       [media] doc-rst: convert fourcc to rst format
>       [media] doc-rst: convert cafe_ccic file to rst format
>       [media] doc-rst: add gspca cardlist
>       [media] doc-rst: add Zoran zr364xx documentation
>       [media] doc-rst: add documentation for cpia2 driver
>       [media] doc-rst: Add cx88 documentation to media book
>       [media] cx88.rst: Update the documentation
>       [media] doc-rst: add davinci-vpbe documentation
>       [media] doc-rst: add documentation for fimc driver
>       [media] doc-rst: Add ivtv documentation
>       [media] doc-rst: add meye documentation
>       [media] doc-rst: add omap3isp documentation
>       [media] doc-rst: add omap4_camera documentation
>       [media] doc-rst: add documentation for pvrusb2
>       [media] doc-rst: add pxa_camera documentation
>       [media] doc-rst: add documentation for radiotrack
>       [media] doc-rst: add documentation for saa7134
>       [media] doc-rst: add sh_mobile_ceu_camera crop documentation
>       [media] doc-rst: add documentation for si470x
>       [media] doc-rst: add documentation for si4713
>       [media] doc-rst: add documentation for si476x
>       [media] doc-rst: add soc-camera documentation
>       [media] doc-rst: add documentation for uvcvideo
>       [media] doc-rst: add documentation for Zoran driver
>       [media] doc-rst: add vivid documentation
>       [media] doc-rst: add documentation about IR on V4L boards
>       [media] v4l-with-ir.rst: update it to reflect the current status
>       [media] doc-rst: move bttv documentation to bttv.rst file
>       [media] doc-rst: add documentation for bttv driver
>       [media] doc-rst: add documentation for tuners
>       [media] doc-rst: start adding documentation for cx2341x
>       [media] cx2341x.rst: add fw-decoder-registers.txt content
>       [media] cx2341x.rst: Add the contents of fw-encoder-api.txt
>       [media] cx2341x.rst: add the contents of fw-calling.txt
>       [media] cx2341x.rst: add contents of fw-dma.txt
>       [media] cx2341x.rst: add contents of fw-memory.txt
>       [media] cx2341x.rst: add the contents of fw-upload.txt
>       [media] cx2341x.rst: add contents of fw-osd-api.txt
>       [media] cx2341x: add contents of README.hm12
>       [media] cx2341x.rst: add contents of README.vbi
>       [media] cx88.rst: add contents from not-in-cx2388x-datasheet.txt
>       [media] cx88.rst: add contents of hauppauge-wintv-cx88-ir.txt
>       [media] get rid of Documentation/video4linux/lifeview.txt
>       [media] doc-rst: fix media kAPI documentation
>       [media] doc-rst: better name the media books
>       [media] doc-rst: backward compatibility with older Sphinx versions
>       Merge branch 'docs-next' of git://git.lwn.net/linux into topic/docs-next
>       Merge branch 'patchwork' into topic/docs-next
>       [media] doc-rst: Fix some Sphinx warnings
>       [media] doc-rst: better organize the media books
>       [media] media-entry.h: Fix a note markup
>       [media] doc-rst: Fix license for the media books
>       [media] v4l2-device.h: document functions
>       [media] doc-rst: Split v4l-core into one file per kAPI
>       [media] v4l2-device.rst: add contents from v4l2-framework
>       [media] v4l2-device.rst: do cross references with kernel-doc
>       [media] v4l2-subdev.rst: add documentation from v4l2-framework.rst
>       [media] v4l2-subdev.h: Improve documentation
>       [media] v4l2-subdev.rst: add cross-references
>       [media] doc-rst: merge v4l2-async.rst with v4l2-subdev.rst
>       [media] v4l2-async: document the remaining stuff
>       [media] v4l2-subdev.rst: add two sections from v4l2-framework.rst
>       [media] v4l2-subdev.rst: add cross references to new sections
>       [media] v4l2-common.h: document the subdev functions
>       [media] v4l2-common.h: Add documentation for other functions
>       [media] mc-core: Fix a cross-reference
>       [media] doc-rst: document v4l2-dev.h
>       [media] doc-rst: move v4l2-dev doc to a separate file
>       [media] v4l2-dev: add cross-references and improve markup
>       [media] v4l2-framework.rst: remove videobuf quick chapter
>       [media] v4l2-event.rst: add text from v4l2-framework.rst
>       [media] v4l2-event.h: document all functions
>       [media] v4l2-event.rst: add cross-references and markups
>       [media] v4l2-fh.h: add documentation for it
>       [media] v4l2-fh.rst: add fh contents from v4l2-framework.rst
>       [media] v4l2-fh.rst: add cross references and markups
>       [media] move V4L2 clocks to a separate .rst file
>       [media] rename v4l2-framework.rst to v4l2-intro.rst
>       [media] doc-rst: reorganize the kAPI v4l2 chapters
>       [media] doc-rst: Fix some typedef ugly warnings
>       [media] v4l2-ctrls.h: fully document the header file
>       [media] dvb_ringbuffer.h: some documentation improvements
>       [media] v4l2-ioctl.h add debug info for struct v4l2_ioctl_ops
>       doc-rst: kernel-doc: fix a change introduced by mistake
>       [media] doc-rst: kapi: use :c:func: instead of :cpp:func
>       [media] doc-rst: add some needed escape codes
>       [media] cx23885-cardlist.rst: add a new card
>       Merge commit '9c1958fc326a0a0a533ec8e86ea6fa30977207de' into v4l_for_linus
>       Merge branch 'topic/docs-next' into v4l_for_linus
> 
>  Documentation/DocBook/device-drivers.tmpl          |    58 -
>  Documentation/DocBook/media/v4l/fdl-appendix.xml   |     2 +-
>  .../DocBook/media/v4l/lirc_device_interface.xml    |     2 +-
>  Documentation/Makefile.sphinx                      |     3 +-
>  Documentation/conf.py                              |    13 +-
>  Documentation/dvb/README.dvb-usb                   |   232 -
>  Documentation/dvb/avermedia.txt                    |   301 -
>  Documentation/dvb/bt8xx.txt                        |    98 -
>  Documentation/dvb/contributors.txt                 |    96 -
>  Documentation/dvb/readme.txt                       |    62 -
>  Documentation/dvb/technisat.txt                    |    78 -
>  Documentation/dvb/ttusb-dec.txt                    |    45 -
>  Documentation/index.rst                            |     4 +
>  Documentation/media/Makefile                       |    60 +
>  Documentation/media/audio.h.rst.exceptions         |    20 +
>  Documentation/media/ca.h.rst.exceptions            |    24 +
>  Documentation/media/cec.h.rst.exceptions           |   492 +
>  Documentation/media/dmx.h.rst.exceptions           |    63 +
>  Documentation/media/dvb-drivers/avermedia.rst      |   267 +
>  Documentation/media/dvb-drivers/bt8xx.rst          |   122 +
>  .../{dvb/cards.txt => media/dvb-drivers/cards.rst} |    71 +-
>  .../{dvb/ci.txt => media/dvb-drivers/ci.rst}       |   186 +-
>  Documentation/media/dvb-drivers/contributors.rst   |   129 +
>  Documentation/media/dvb-drivers/dvb-usb.rst        |   355 +
>  .../{dvb/faq.txt => media/dvb-drivers/faq.rst}     |    18 +-
>  Documentation/media/dvb-drivers/index.rst          |    42 +
>  Documentation/media/dvb-drivers/intro.rst          |    21 +
>  .../lmedm04.txt => media/dvb-drivers/lmedm04.rst}  |    72 +-
>  .../dvb-drivers/opera-firmware.rst}                |    14 +-
>  Documentation/media/dvb-drivers/technisat.rst      |    98 +
>  Documentation/media/dvb-drivers/ttusb-dec.rst      |    43 +
>  .../{dvb/udev.txt => media/dvb-drivers/udev.rst}   |    31 +-
>  Documentation/media/frontend.h.rst.exceptions      |    47 +
>  Documentation/media/intro.rst                      |    46 +
>  Documentation/media/kapi/dtv-core.rst              |   132 +
>  Documentation/media/kapi/mc-core.rst               |   263 +
>  Documentation/media/kapi/rc-core.rst               |    14 +
>  Documentation/media/kapi/v4l2-clocks.rst           |    29 +
>  Documentation/media/kapi/v4l2-common.rst           |     6 +
>  .../kapi/v4l2-controls.rst}                        |   162 +-
>  Documentation/media/kapi/v4l2-core.rst             |    26 +
>  Documentation/media/kapi/v4l2-dev.rst              |   363 +
>  Documentation/media/kapi/v4l2-device.rst           |   144 +
>  Documentation/media/kapi/v4l2-dv-timings.rst       |     4 +
>  Documentation/media/kapi/v4l2-event.rst            |   137 +
>  Documentation/media/kapi/v4l2-fh.rst               |   139 +
>  Documentation/media/kapi/v4l2-flash-led-class.rst  |     4 +
>  Documentation/media/kapi/v4l2-intro.rst            |    74 +
>  Documentation/media/kapi/v4l2-mc.rst               |     4 +
>  Documentation/media/kapi/v4l2-mediabus.rst         |     4 +
>  Documentation/media/kapi/v4l2-mem2mem.rst          |     4 +
>  Documentation/media/kapi/v4l2-of.rst               |     3 +
>  Documentation/media/kapi/v4l2-rect.rst             |     4 +
>  Documentation/media/kapi/v4l2-subdev.rst           |   445 +
>  Documentation/media/kapi/v4l2-tuner.rst            |     6 +
>  Documentation/media/kapi/v4l2-tveeprom.rst         |     4 +
>  .../videobuf => media/kapi/v4l2-videobuf.rst}      |    53 +-
>  Documentation/media/kapi/v4l2-videobuf2.rst        |    10 +
>  Documentation/media/lirc.h.rst.exceptions          |    43 +
>  Documentation/media/media.h.rst.exceptions         |    30 +
>  .../media/media_api_files/typical_media_device.pdf |   Bin 0 -> 134268 bytes
>  .../media/media_api_files/typical_media_device.svg |    28 +
>  Documentation/media/media_kapi.rst                 |    34 +
>  Documentation/media/media_uapi.rst                 |    31 +
>  Documentation/media/net.h.rst.exceptions           |    11 +
>  Documentation/media/uapi/cec/cec-api.rst           |    43 +
>  Documentation/media/uapi/cec/cec-func-close.rst    |    49 +
>  Documentation/media/uapi/cec/cec-func-ioctl.rst    |    68 +
>  Documentation/media/uapi/cec/cec-func-open.rst     |    80 +
>  Documentation/media/uapi/cec/cec-func-poll.rst     |    70 +
>  Documentation/media/uapi/cec/cec-funcs.rst         |    21 +
>  Documentation/media/uapi/cec/cec-header.rst        |    10 +
>  Documentation/media/uapi/cec/cec-intro.rst         |    31 +
>  .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |   165 +
>  .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |   436 +
>  .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    |    82 +
>  Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |   231 +
>  Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |   295 +
>  Documentation/media/uapi/cec/cec-ioc-receive.rst   |   360 +
>  .../uapi/dvb/audio-bilingual-channel-select.rst    |    64 +
>  .../media/uapi/dvb/audio-channel-select.rst        |    63 +
>  .../media/uapi/dvb/audio-clear-buffer.rst          |    54 +
>  Documentation/media/uapi/dvb/audio-continue.rst    |    54 +
>  Documentation/media/uapi/dvb/audio-fclose.rst      |    54 +
>  Documentation/media/uapi/dvb/audio-fopen.rst       |   104 +
>  Documentation/media/uapi/dvb/audio-fwrite.rst      |    82 +
>  .../media/uapi/dvb/audio-get-capabilities.rst      |    60 +
>  Documentation/media/uapi/dvb/audio-get-pts.rst     |    69 +
>  Documentation/media/uapi/dvb/audio-get-status.rst  |    60 +
>  Documentation/media/uapi/dvb/audio-pause.rst       |    55 +
>  Documentation/media/uapi/dvb/audio-play.rst        |    54 +
>  .../media/uapi/dvb/audio-select-source.rst         |    62 +
>  .../media/uapi/dvb/audio-set-attributes.rst        |    71 +
>  Documentation/media/uapi/dvb/audio-set-av-sync.rst |    70 +
>  .../media/uapi/dvb/audio-set-bypass-mode.rst       |    74 +
>  Documentation/media/uapi/dvb/audio-set-ext-id.rst  |    71 +
>  Documentation/media/uapi/dvb/audio-set-id.rst      |    65 +
>  Documentation/media/uapi/dvb/audio-set-karaoke.rst |    70 +
>  Documentation/media/uapi/dvb/audio-set-mixer.rst   |    59 +
>  Documentation/media/uapi/dvb/audio-set-mute.rst    |    74 +
>  .../media/uapi/dvb/audio-set-streamtype.rst        |    74 +
>  Documentation/media/uapi/dvb/audio-stop.rst        |    54 +
>  Documentation/media/uapi/dvb/audio.rst             |    26 +
>  Documentation/media/uapi/dvb/audio_data_types.rst  |   176 +
>  .../media/uapi/dvb/audio_function_calls.rst        |    34 +
>  Documentation/media/uapi/dvb/audio_h.rst           |     9 +
>  Documentation/media/uapi/dvb/ca-fclose.rst         |    54 +
>  Documentation/media/uapi/dvb/ca-fopen.rst          |   109 +
>  Documentation/media/uapi/dvb/ca-get-cap.rst        |    59 +
>  Documentation/media/uapi/dvb/ca-get-descr-info.rst |    59 +
>  Documentation/media/uapi/dvb/ca-get-msg.rst        |    59 +
>  Documentation/media/uapi/dvb/ca-get-slot-info.rst  |    59 +
>  Documentation/media/uapi/dvb/ca-reset.rst          |    53 +
>  Documentation/media/uapi/dvb/ca-send-msg.rst       |    59 +
>  Documentation/media/uapi/dvb/ca-set-descr.rst      |    59 +
>  Documentation/media/uapi/dvb/ca-set-pid.rst        |    59 +
>  Documentation/media/uapi/dvb/ca.rst                |    18 +
>  Documentation/media/uapi/dvb/ca_data_types.rst     |   110 +
>  Documentation/media/uapi/dvb/ca_function_calls.rst |    21 +
>  Documentation/media/uapi/dvb/ca_h.rst              |     9 +
>  Documentation/media/uapi/dvb/demux.rst             |    18 +
>  Documentation/media/uapi/dvb/dmx-add-pid.rst       |    61 +
>  Documentation/media/uapi/dvb/dmx-fclose.rst        |    55 +
>  Documentation/media/uapi/dvb/dmx-fopen.rst         |   108 +
>  Documentation/media/uapi/dvb/dmx-fread.rst         |   108 +
>  Documentation/media/uapi/dvb/dmx-fwrite.rst        |    89 +
>  Documentation/media/uapi/dvb/dmx-get-caps.rst      |    59 +
>  Documentation/media/uapi/dvb/dmx-get-event.rst     |    76 +
>  Documentation/media/uapi/dvb/dmx-get-pes-pids.rst  |    59 +
>  Documentation/media/uapi/dvb/dmx-get-stc.rst       |    77 +
>  Documentation/media/uapi/dvb/dmx-remove-pid.rst    |    62 +
>  .../media/uapi/dvb/dmx-set-buffer-size.rst         |    62 +
>  Documentation/media/uapi/dvb/dmx-set-filter.rst    |    68 +
>  .../media/uapi/dvb/dmx-set-pes-filter.rst          |    78 +
>  Documentation/media/uapi/dvb/dmx-set-source.rst    |    59 +
>  Documentation/media/uapi/dvb/dmx-start.rst         |    77 +
>  Documentation/media/uapi/dvb/dmx-stop.rst          |    55 +
>  Documentation/media/uapi/dvb/dmx_fcalls.rst        |    27 +
>  Documentation/media/uapi/dvb/dmx_h.rst             |     9 +
>  Documentation/media/uapi/dvb/dmx_types.rst         |   242 +
>  Documentation/media/uapi/dvb/dtv-fe-stats.rst      |    17 +
>  Documentation/media/uapi/dvb/dtv-properties.rst    |    15 +
>  Documentation/media/uapi/dvb/dtv-property.rst      |    31 +
>  Documentation/media/uapi/dvb/dtv-stats.rst         |    18 +
>  .../media/uapi/dvb/dvb-fe-read-status.rst          |    23 +
>  .../media/uapi/dvb/dvb-frontend-event.rst          |    15 +
>  .../media/uapi/dvb/dvb-frontend-parameters.rst     |   119 +
>  Documentation/media/uapi/dvb/dvbapi.rst            |   102 +
>  Documentation/media/uapi/dvb/dvbproperty-006.rst   |    12 +
>  Documentation/media/uapi/dvb/dvbproperty.rst       |   116 +
>  Documentation/media/uapi/dvb/examples.rst          |   380 +
>  Documentation/media/uapi/dvb/fe-bandwidth-t.rst    |    77 +
>  .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |    83 +
>  .../media/uapi/dvb/fe-diseqc-reset-overload.rst    |    45 +
>  .../media/uapi/dvb/fe-diseqc-send-burst.rst        |    84 +
>  .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |    73 +
>  .../uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst    |    55 +
>  .../media/uapi/dvb/fe-enable-high-lnb-voltage.rst  |    52 +
>  Documentation/media/uapi/dvb/fe-get-event.rst      |    87 +
>  Documentation/media/uapi/dvb/fe-get-frontend.rst   |    74 +
>  Documentation/media/uapi/dvb/fe-get-info.rst       |   428 +
>  Documentation/media/uapi/dvb/fe-get-property.rst   |    68 +
>  Documentation/media/uapi/dvb/fe-read-ber.rst       |    60 +
>  .../media/uapi/dvb/fe-read-signal-strength.rst     |    63 +
>  Documentation/media/uapi/dvb/fe-read-snr.rst       |    61 +
>  Documentation/media/uapi/dvb/fe-read-status.rst    |   135 +
>  .../media/uapi/dvb/fe-read-uncorrected-blocks.rst  |    65 +
>  .../media/uapi/dvb/fe-set-frontend-tune-mode.rst   |    55 +
>  Documentation/media/uapi/dvb/fe-set-frontend.rst   |    79 +
>  Documentation/media/uapi/dvb/fe-set-tone.rst       |    91 +
>  Documentation/media/uapi/dvb/fe-set-voltage.rst    |    63 +
>  Documentation/media/uapi/dvb/fe-type-t.rst         |    91 +
>  .../media/uapi/dvb/fe_property_parameters.rst      |  1979 ++++
>  .../uapi/dvb/frontend-property-cable-systems.rst   |    75 +
>  .../dvb/frontend-property-satellite-systems.rst    |   103 +
>  .../dvb/frontend-property-terrestrial-systems.rst  |   294 +
>  .../media/uapi/dvb/frontend-stat-properties.rst    |   245 +
>  Documentation/media/uapi/dvb/frontend.rst          |    51 +
>  Documentation/media/uapi/dvb/frontend_f_close.rst  |    48 +
>  Documentation/media/uapi/dvb/frontend_f_open.rst   |   102 +
>  Documentation/media/uapi/dvb/frontend_fcalls.rst   |    24 +
>  Documentation/media/uapi/dvb/frontend_h.rst        |     9 +
>  .../media/uapi/dvb/frontend_legacy_api.rst         |    38 +
>  .../media/uapi/dvb/frontend_legacy_dvbv3_api.rst   |    18 +
>  Documentation/media/uapi/dvb/intro.rst             |   172 +
>  .../media/uapi/dvb/intro_files/dvbstb.pdf          |   Bin 0 -> 1881 bytes
>  .../media/uapi/dvb/intro_files/dvbstb.png          |   Bin 0 -> 22655 bytes
>  Documentation/media/uapi/dvb/legacy_dvb_apis.rst   |    20 +
>  Documentation/media/uapi/dvb/net-add-if.rst        |    91 +
>  Documentation/media/uapi/dvb/net-get-if.rst        |    50 +
>  Documentation/media/uapi/dvb/net-remove-if.rst     |    46 +
>  Documentation/media/uapi/dvb/net.rst               |    40 +
>  Documentation/media/uapi/dvb/net_h.rst             |     9 +
>  .../media/uapi/dvb/query-dvb-frontend-info.rst     |    13 +
>  .../media/uapi/dvb/video-clear-buffer.rst          |    54 +
>  Documentation/media/uapi/dvb/video-command.rst     |    66 +
>  Documentation/media/uapi/dvb/video-continue.rst    |    57 +
>  .../media/uapi/dvb/video-fast-forward.rst          |    74 +
>  Documentation/media/uapi/dvb/video-fclose.rst      |    54 +
>  Documentation/media/uapi/dvb/video-fopen.rst       |   112 +
>  Documentation/media/uapi/dvb/video-freeze.rst      |    61 +
>  Documentation/media/uapi/dvb/video-fwrite.rst      |    82 +
>  .../media/uapi/dvb/video-get-capabilities.rst      |    61 +
>  Documentation/media/uapi/dvb/video-get-event.rst   |    88 +
>  .../media/uapi/dvb/video-get-frame-count.rst       |    65 +
>  .../media/uapi/dvb/video-get-frame-rate.rst        |    59 +
>  Documentation/media/uapi/dvb/video-get-navi.rst    |    74 +
>  Documentation/media/uapi/dvb/video-get-pts.rst     |    69 +
>  Documentation/media/uapi/dvb/video-get-size.rst    |    59 +
>  Documentation/media/uapi/dvb/video-get-status.rst  |    60 +
>  Documentation/media/uapi/dvb/video-play.rst        |    57 +
>  .../media/uapi/dvb/video-select-source.rst         |    65 +
>  .../media/uapi/dvb/video-set-attributes.rst        |    75 +
>  Documentation/media/uapi/dvb/video-set-blank.rst   |    64 +
>  .../media/uapi/dvb/video-set-display-format.rst    |    60 +
>  Documentation/media/uapi/dvb/video-set-format.rst  |    74 +
>  .../media/uapi/dvb/video-set-highlight.rst         |    60 +
>  Documentation/media/uapi/dvb/video-set-id.rst      |    73 +
>  .../media/uapi/dvb/video-set-spu-palette.rst       |    72 +
>  Documentation/media/uapi/dvb/video-set-spu.rst     |    74 +
>  .../media/uapi/dvb/video-set-streamtype.rst        |    61 +
>  Documentation/media/uapi/dvb/video-set-system.rst  |    75 +
>  Documentation/media/uapi/dvb/video-slowmotion.rst  |    74 +
>  .../media/uapi/dvb/video-stillpicture.rst          |    61 +
>  Documentation/media/uapi/dvb/video-stop.rst        |    74 +
>  Documentation/media/uapi/dvb/video-try-command.rst |    66 +
>  Documentation/media/uapi/dvb/video.rst             |    35 +
>  .../media/uapi/dvb/video_function_calls.rst        |    43 +
>  Documentation/media/uapi/dvb/video_h.rst           |     9 +
>  Documentation/media/uapi/dvb/video_types.rst       |   379 +
>  Documentation/media/uapi/fdl-appendix.rst          |   471 +
>  Documentation/media/uapi/gen-errors.rst            |   103 +
>  .../media/uapi/mediactl/media-controller-intro.rst |    33 +
>  .../media/uapi/mediactl/media-controller-model.rst |    35 +
>  .../media/uapi/mediactl/media-controller.rst       |    52 +
>  .../media/uapi/mediactl/media-func-close.rst       |    47 +
>  .../media/uapi/mediactl/media-func-ioctl.rst       |    67 +
>  .../media/uapi/mediactl/media-func-open.rst        |    69 +
>  Documentation/media/uapi/mediactl/media-funcs.rst  |    18 +
>  Documentation/media/uapi/mediactl/media-header.rst |    10 +
>  .../media/uapi/mediactl/media-ioc-device-info.rst  |   142 +
>  .../uapi/mediactl/media-ioc-enum-entities.rst      |   199 +
>  .../media/uapi/mediactl/media-ioc-enum-links.rst   |   170 +
>  .../media/uapi/mediactl/media-ioc-g-topology.rst   |   377 +
>  .../media/uapi/mediactl/media-ioc-setup-link.rst   |    68 +
>  Documentation/media/uapi/mediactl/media-types.rst  |   606 +
>  Documentation/media/uapi/rc/keytable.c.rst         |   176 +
>  Documentation/media/uapi/rc/lirc-dev-intro.rst     |    62 +
>  Documentation/media/uapi/rc/lirc-dev.rst           |    14 +
>  Documentation/media/uapi/rc/lirc-func.rst          |    28 +
>  Documentation/media/uapi/rc/lirc-get-features.rst  |   181 +
>  Documentation/media/uapi/rc/lirc-get-length.rst    |    45 +
>  Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |    45 +
>  .../media/uapi/rc/lirc-get-rec-resolution.rst      |    49 +
>  Documentation/media/uapi/rc/lirc-get-send-mode.rst |    45 +
>  Documentation/media/uapi/rc/lirc-get-timeout.rst   |    55 +
>  Documentation/media/uapi/rc/lirc-header.rst        |    10 +
>  Documentation/media/uapi/rc/lirc-read.rst          |    62 +
>  .../uapi/rc/lirc-set-measure-carrier-mode.rst      |    48 +
>  .../media/uapi/rc/lirc-set-rec-carrier-range.rst   |    49 +
>  .../media/uapi/rc/lirc-set-rec-carrier.rst         |    48 +
>  .../media/uapi/rc/lirc-set-rec-timeout-reports.rst |    49 +
>  .../media/uapi/rc/lirc-set-rec-timeout.rst         |    52 +
>  .../media/uapi/rc/lirc-set-send-carrier.rst        |    43 +
>  .../media/uapi/rc/lirc-set-send-duty-cycle.rst     |    49 +
>  .../media/uapi/rc/lirc-set-transmitter-mask.rst    |    53 +
>  .../media/uapi/rc/lirc-set-wideband-receiver.rst   |    56 +
>  Documentation/media/uapi/rc/lirc-write.rst         |    58 +
>  Documentation/media/uapi/rc/rc-intro.rst           |    24 +
>  Documentation/media/uapi/rc/rc-sysfs-nodes.rst     |   143 +
>  Documentation/media/uapi/rc/rc-table-change.rst    |    18 +
>  Documentation/media/uapi/rc/rc-tables.rst          |   757 ++
>  Documentation/media/uapi/rc/remote_controllers.rst |    49 +
>  Documentation/media/uapi/v4l/app-pri.rst           |    30 +
>  Documentation/media/uapi/v4l/async.rst             |     9 +
>  Documentation/media/uapi/v4l/audio.rst             |    95 +
>  Documentation/media/uapi/v4l/biblio.rst            |   391 +
>  Documentation/media/uapi/v4l/buffer.rst            |   982 ++
>  Documentation/media/uapi/v4l/capture-example.rst   |    13 +
>  Documentation/media/uapi/v4l/capture.c.rst         |   664 ++
>  Documentation/media/uapi/v4l/colorspaces.rst       |   163 +
>  Documentation/media/uapi/v4l/common-defs.rst       |    13 +
>  Documentation/media/uapi/v4l/common.rst            |    46 +
>  Documentation/media/uapi/v4l/compat.rst            |    18 +
>  Documentation/media/uapi/v4l/control.rst           |   538 +
>  Documentation/media/uapi/v4l/crop.rst              |   303 +
>  Documentation/media/uapi/v4l/crop_files/crop.gif   |   Bin 0 -> 5967 bytes
>  Documentation/media/uapi/v4l/crop_files/crop.pdf   |   Bin 0 -> 5846 bytes
>  Documentation/media/uapi/v4l/depth-formats.rst     |    15 +
>  Documentation/media/uapi/v4l/dev-capture.rst       |   104 +
>  Documentation/media/uapi/v4l/dev-codec.rst         |    34 +
>  Documentation/media/uapi/v4l/dev-effect.rst        |    21 +
>  Documentation/media/uapi/v4l/dev-event.rst         |    47 +
>  Documentation/media/uapi/v4l/dev-osd.rst           |   148 +
>  Documentation/media/uapi/v4l/dev-output.rst        |   101 +
>  Documentation/media/uapi/v4l/dev-overlay.rst       |   317 +
>  Documentation/media/uapi/v4l/dev-radio.rst         |    52 +
>  Documentation/media/uapi/v4l/dev-raw-vbi.rst       |   350 +
>  .../media/uapi/v4l/dev-raw-vbi_files/vbi_525.gif   |   Bin 0 -> 4741 bytes
>  .../media/uapi/v4l/dev-raw-vbi_files/vbi_525.pdf   |   Bin 0 -> 3395 bytes
>  .../media/uapi/v4l/dev-raw-vbi_files/vbi_625.gif   |   Bin 0 -> 5095 bytes
>  .../media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf   |   Bin 0 -> 3683 bytes
>  .../media/uapi/v4l/dev-raw-vbi_files/vbi_hsync.gif |   Bin 0 -> 2400 bytes
>  .../media/uapi/v4l/dev-raw-vbi_files/vbi_hsync.pdf |   Bin 0 -> 7405 bytes
>  Documentation/media/uapi/v4l/dev-rds.rst           |   255 +
>  Documentation/media/uapi/v4l/dev-sdr.rst           |   120 +
>  Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |   822 ++
>  Documentation/media/uapi/v4l/dev-subdev.rst        |   491 +
>  .../media/uapi/v4l/dev-subdev_files/pipeline.pdf   |   Bin 0 -> 20276 bytes
>  .../media/uapi/v4l/dev-subdev_files/pipeline.png   |   Bin 0 -> 12130 bytes
>  .../subdev-image-processing-crop.pdf               |   Bin 0 -> 20729 bytes
>  .../subdev-image-processing-crop.svg               |    63 +
>  .../subdev-image-processing-full.pdf               |   Bin 0 -> 46311 bytes
>  .../subdev-image-processing-full.svg               |   163 +
>  ...ubdev-image-processing-scaling-multi-source.pdf |   Bin 0 -> 36714 bytes
>  ...ubdev-image-processing-scaling-multi-source.svg |   116 +
>  Documentation/media/uapi/v4l/dev-teletext.rst      |    34 +
>  Documentation/media/uapi/v4l/devices.rst           |    26 +
>  Documentation/media/uapi/v4l/diff-v4l.rst          |   954 ++
>  Documentation/media/uapi/v4l/dmabuf.rst            |   162 +
>  Documentation/media/uapi/v4l/driver.rst            |     9 +
>  Documentation/media/uapi/v4l/dv-timings.rst        |    38 +
>  Documentation/media/uapi/v4l/extended-controls.rst |  4531 +++++++
>  Documentation/media/uapi/v4l/field-order.rst       |   205 +
>  .../uapi/v4l/field-order_files/fieldseq_bt.gif     |   Bin 0 -> 25430 bytes
>  .../uapi/v4l/field-order_files/fieldseq_bt.pdf     |   Bin 0 -> 9185 bytes
>  .../uapi/v4l/field-order_files/fieldseq_tb.gif     |   Bin 0 -> 25323 bytes
>  .../uapi/v4l/field-order_files/fieldseq_tb.pdf     |   Bin 0 -> 9173 bytes
>  Documentation/media/uapi/v4l/format.rst            |    92 +
>  Documentation/media/uapi/v4l/func-close.rst        |    49 +
>  Documentation/media/uapi/v4l/func-ioctl.rst        |    62 +
>  Documentation/media/uapi/v4l/func-mmap.rst         |   139 +
>  Documentation/media/uapi/v4l/func-munmap.rst       |    58 +
>  Documentation/media/uapi/v4l/func-open.rst         |    83 +
>  Documentation/media/uapi/v4l/func-poll.rst         |   116 +
>  Documentation/media/uapi/v4l/func-read.rst         |   131 +
>  Documentation/media/uapi/v4l/func-select.rst       |   106 +
>  Documentation/media/uapi/v4l/func-write.rst        |    82 +
>  Documentation/media/uapi/v4l/hist-v4l2.rst         |  1480 +++
>  Documentation/media/uapi/v4l/io.rst                |    51 +
>  .../media/uapi/v4l/libv4l-introduction.rst         |   169 +
>  Documentation/media/uapi/v4l/libv4l.rst            |    13 +
>  Documentation/media/uapi/v4l/mmap.rst              |   285 +
>  Documentation/media/uapi/v4l/open.rst              |   158 +
>  Documentation/media/uapi/v4l/pixfmt-002.rst        |   196 +
>  Documentation/media/uapi/v4l/pixfmt-003.rst        |   166 +
>  Documentation/media/uapi/v4l/pixfmt-004.rst        |    51 +
>  Documentation/media/uapi/v4l/pixfmt-006.rst        |   288 +
>  Documentation/media/uapi/v4l/pixfmt-007.rst        |   896 ++
>  Documentation/media/uapi/v4l/pixfmt-008.rst        |    32 +
>  Documentation/media/uapi/v4l/pixfmt-013.rst        |   129 +
>  Documentation/media/uapi/v4l/pixfmt-grey.rst       |    77 +
>  Documentation/media/uapi/v4l/pixfmt-indexed.rst    |    73 +
>  Documentation/media/uapi/v4l/pixfmt-m420.rst       |   219 +
>  Documentation/media/uapi/v4l/pixfmt-nv12.rst       |   221 +
>  Documentation/media/uapi/v4l/pixfmt-nv12m.rst      |   238 +
>  Documentation/media/uapi/v4l/pixfmt-nv12mt.rst     |    62 +
>  .../media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif  |   Bin 0 -> 2108 bytes
>  .../v4l/pixfmt-nv12mt_files/nv12mt_example.gif     |   Bin 0 -> 6858 bytes
>  Documentation/media/uapi/v4l/pixfmt-nv16.rst       |   270 +
>  Documentation/media/uapi/v4l/pixfmt-nv16m.rst      |   277 +
>  Documentation/media/uapi/v4l/pixfmt-nv24.rst       |   171 +
>  Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst |  1469 +++
>  Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst |   316 +
>  Documentation/media/uapi/v4l/pixfmt-reserved.rst   |   360 +
>  Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    23 +
>  Documentation/media/uapi/v4l/pixfmt-sbggr16.rst    |   114 +
>  Documentation/media/uapi/v4l/pixfmt-sbggr8.rst     |    81 +
>  Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst   |    43 +
>  Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst |    48 +
>  Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst   |    43 +
>  Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst |    47 +
>  Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst |    38 +
>  Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst     |    81 +
>  Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst     |    81 +
>  Documentation/media/uapi/v4l/pixfmt-srggb10.rst    |   120 +
>  .../media/uapi/v4l/pixfmt-srggb10alaw8.rst         |    26 +
>  .../media/uapi/v4l/pixfmt-srggb10dpcm8.rst         |    28 +
>  Documentation/media/uapi/v4l/pixfmt-srggb10p.rst   |   103 +
>  Documentation/media/uapi/v4l/pixfmt-srggb12.rst    |   121 +
>  Documentation/media/uapi/v4l/pixfmt-srggb8.rst     |    81 +
>  Documentation/media/uapi/v4l/pixfmt-uv8.rst        |    76 +
>  Documentation/media/uapi/v4l/pixfmt-uyvy.rst       |   197 +
>  Documentation/media/uapi/v4l/pixfmt-vyuy.rst       |   195 +
>  Documentation/media/uapi/v4l/pixfmt-y10.rst        |   110 +
>  Documentation/media/uapi/v4l/pixfmt-y10b.rst       |    45 +
>  Documentation/media/uapi/v4l/pixfmt-y12.rst        |   110 +
>  Documentation/media/uapi/v4l/pixfmt-y12i.rst       |    44 +
>  Documentation/media/uapi/v4l/pixfmt-y16-be.rst     |   112 +
>  Documentation/media/uapi/v4l/pixfmt-y16.rst        |   112 +
>  Documentation/media/uapi/v4l/pixfmt-y41p.rst       |   274 +
>  Documentation/media/uapi/v4l/pixfmt-y8i.rst        |   111 +
>  Documentation/media/uapi/v4l/pixfmt-yuv410.rst     |   208 +
>  Documentation/media/uapi/v4l/pixfmt-yuv411p.rst    |   214 +
>  Documentation/media/uapi/v4l/pixfmt-yuv420.rst     |   239 +
>  Documentation/media/uapi/v4l/pixfmt-yuv420m.rst    |   254 +
>  Documentation/media/uapi/v4l/pixfmt-yuv422m.rst    |   258 +
>  Documentation/media/uapi/v4l/pixfmt-yuv422p.rst    |   240 +
>  Documentation/media/uapi/v4l/pixfmt-yuv444m.rst    |   266 +
>  Documentation/media/uapi/v4l/pixfmt-yuyv.rst       |   205 +
>  Documentation/media/uapi/v4l/pixfmt-yvyu.rst       |   195 +
>  Documentation/media/uapi/v4l/pixfmt-z16.rst        |   111 +
>  Documentation/media/uapi/v4l/pixfmt.rst            |    35 +
>  Documentation/media/uapi/v4l/planar-apis.rst       |    61 +
>  Documentation/media/uapi/v4l/querycap.rst          |    34 +
>  Documentation/media/uapi/v4l/rw.rst                |    47 +
>  Documentation/media/uapi/v4l/sdr-formats.rst       |    19 +
>  Documentation/media/uapi/v4l/selection-api-002.rst |    28 +
>  Documentation/media/uapi/v4l/selection-api-003.rst |    20 +
>  .../uapi/v4l/selection-api-003_files/selection.png |   Bin 0 -> 11716 bytes
>  Documentation/media/uapi/v4l/selection-api-004.rst |   137 +
>  Documentation/media/uapi/v4l/selection-api-005.rst |    34 +
>  Documentation/media/uapi/v4l/selection-api-006.rst |    84 +
>  Documentation/media/uapi/v4l/selection-api.rst     |    16 +
>  Documentation/media/uapi/v4l/selections-common.rst |    23 +
>  Documentation/media/uapi/v4l/standard.rst          |   183 +
>  Documentation/media/uapi/v4l/streaming-par.rst     |    33 +
>  Documentation/media/uapi/v4l/subdev-formats.rst    | 11688 +++++++++++++++++++
>  .../media/uapi/v4l/subdev-formats_files/bayer.png  |   Bin 0 -> 9725 bytes
>  Documentation/media/uapi/v4l/tuner.rst             |    83 +
>  Documentation/media/uapi/v4l/user-func.rst         |    81 +
>  Documentation/media/uapi/v4l/userp.rst             |   119 +
>  .../media/uapi/v4l/v4l2-selection-flags.rst        |    71 +
>  .../media/uapi/v4l/v4l2-selection-targets.rst      |   135 +
>  Documentation/media/uapi/v4l/v4l2.rst              |   398 +
>  Documentation/media/uapi/v4l/v4l2grab-example.rst  |    17 +
>  Documentation/media/uapi/v4l/v4l2grab.c.rst        |   169 +
>  Documentation/media/uapi/v4l/video.rst             |    67 +
>  Documentation/media/uapi/v4l/videodev.rst          |     9 +
>  .../media/uapi/v4l/vidioc-create-bufs.rst          |   146 +
>  Documentation/media/uapi/v4l/vidioc-cropcap.rst    |   167 +
>  .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      |   204 +
>  .../media/uapi/v4l/vidioc-dbg-g-register.rst       |   209 +
>  .../media/uapi/v4l/vidioc-decoder-cmd.rst          |   271 +
>  Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   573 +
>  .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |   252 +
>  .../media/uapi/v4l/vidioc-encoder-cmd.rst          |   195 +
>  .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |   121 +
>  Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   166 +
>  .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |   270 +
>  .../media/uapi/v4l/vidioc-enum-framesizes.rst      |   291 +
>  .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |   192 +
>  Documentation/media/uapi/v4l/vidioc-enumaudio.rst  |    56 +
>  .../media/uapi/v4l/vidioc-enumaudioout.rst         |    59 +
>  Documentation/media/uapi/v4l/vidioc-enuminput.rst  |   367 +
>  Documentation/media/uapi/v4l/vidioc-enumoutput.rst |   222 +
>  Documentation/media/uapi/v4l/vidioc-enumstd.rst    |   442 +
>  Documentation/media/uapi/v4l/vidioc-expbuf.rst     |   197 +
>  Documentation/media/uapi/v4l/vidioc-g-audio.rst    |   162 +
>  Documentation/media/uapi/v4l/vidioc-g-audioout.rst |   122 +
>  Documentation/media/uapi/v4l/vidioc-g-crop.rst     |   113 +
>  Documentation/media/uapi/v4l/vidioc-g-ctrl.rst     |   105 +
>  .../media/uapi/v4l/vidioc-g-dv-timings.rst         |   417 +
>  Documentation/media/uapi/v4l/vidioc-g-edid.rst     |   160 +
>  .../media/uapi/v4l/vidioc-g-enc-index.rst          |   210 +
>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |   492 +
>  Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |   500 +
>  Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |   188 +
>  .../media/uapi/v4l/vidioc-g-frequency.rst          |   123 +
>  Documentation/media/uapi/v4l/vidioc-g-input.rst    |    62 +
>  Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |   184 +
>  .../media/uapi/v4l/vidioc-g-modulator.rst          |   257 +
>  Documentation/media/uapi/v4l/vidioc-g-output.rst   |    64 +
>  Documentation/media/uapi/v4l/vidioc-g-parm.rst     |   349 +
>  Documentation/media/uapi/v4l/vidioc-g-priority.rst |   117 +
>  .../media/uapi/v4l/vidioc-g-selection.rst          |   209 +
>  .../v4l/vidioc-g-selection_files/constraints.png   |   Bin 0 -> 3313 bytes
>  .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |   276 +
>  Documentation/media/uapi/v4l/vidioc-g-std.rst      |    68 +
>  Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |   717 ++
>  Documentation/media/uapi/v4l/vidioc-log-status.rst |    46 +
>  Documentation/media/uapi/v4l/vidioc-overlay.rst    |    55 +
>  .../media/uapi/v4l/vidioc-prepare-buf.rst          |    62 +
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst       |   151 +
>  .../media/uapi/v4l/vidioc-query-dv-timings.rst     |    83 +
>  Documentation/media/uapi/v4l/vidioc-querybuf.rst   |    81 +
>  Documentation/media/uapi/v4l/vidioc-querycap.rst   |   434 +
>  Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |   785 ++
>  Documentation/media/uapi/v4l/vidioc-querystd.rst   |    66 +
>  Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |   125 +
>  .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |   179 +
>  Documentation/media/uapi/v4l/vidioc-streamon.rst   |   103 +
>  .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst |   153 +
>  .../uapi/v4l/vidioc-subdev-enum-frame-size.rst     |   162 +
>  .../uapi/v4l/vidioc-subdev-enum-mbus-code.rst      |   115 +
>  .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |   136 +
>  .../media/uapi/v4l/vidioc-subdev-g-fmt.rst         |   171 +
>  .../uapi/v4l/vidioc-subdev-g-frame-interval.rst    |   122 +
>  .../media/uapi/v4l/vidioc-subdev-g-selection.rst   |   144 +
>  .../media/uapi/v4l/vidioc-subscribe-event.rst      |   138 +
>  Documentation/media/uapi/v4l/yuv-formats.rst       |    55 +
>  .../media/v4l-drivers/au0828-cardlist.rst          |    11 +
>  Documentation/media/v4l-drivers/bttv-cardlist.rst  |   172 +
>  Documentation/media/v4l-drivers/bttv.rst           |  1923 +++
>  .../cafe_ccic => media/v4l-drivers/cafe_ccic.rst}  |    24 +-
>  Documentation/media/v4l-drivers/cardlist.rst       |    18 +
>  Documentation/media/v4l-drivers/cpia2.rst          |   190 +
>  .../cx18.txt => media/v4l-drivers/cx18.rst}        |     7 +
>  Documentation/media/v4l-drivers/cx2341x.rst        |  3858 ++++++
>  .../media/v4l-drivers/cx23885-cardlist.rst         |    62 +
>  Documentation/media/v4l-drivers/cx88-cardlist.rst  |    96 +
>  Documentation/media/v4l-drivers/cx88.rst           |   163 +
>  .../v4l-drivers/davinci-vpbe.rst}                  |    32 +-
>  .../media/v4l-drivers/em28xx-cardlist.rst          |   105 +
>  .../fimc.txt => media/v4l-drivers/fimc.rst}        |   105 +-
>  .../4CCs.txt => media/v4l-drivers/fourcc.rst}      |    20 +-
>  .../v4l-drivers/gspca-cardlist.rst}                |    16 +-
>  Documentation/media/v4l-drivers/index.rst          |    58 +
>  Documentation/media/v4l-drivers/ivtv-cardlist.rst  |    29 +
>  Documentation/media/v4l-drivers/ivtv.rst           |   217 +
>  .../meye.txt => media/v4l-drivers/meye.rst}        |   103 +-
>  .../v4l-drivers/omap3isp.rst}                      |   135 +-
>  .../v4l-drivers/omap4_camera.rst}                  |    28 +-
>  .../v4l-drivers/pvrusb2.rst}                       |   164 +-
>  Documentation/media/v4l-drivers/pxa_camera.rst     |   192 +
>  Documentation/media/v4l-drivers/radiotrack.rst     |   166 +
>  .../media/v4l-drivers/saa7134-cardlist.rst         |   202 +
>  Documentation/media/v4l-drivers/saa7134.rst        |   113 +
>  .../media/v4l-drivers/saa7164-cardlist.rst         |    19 +
>  .../v4l-drivers/sh_mobile_ceu_camera.rst}          |    57 +-
>  .../si470x.txt => media/v4l-drivers/si470x.rst}    |    74 +-
>  Documentation/media/v4l-drivers/si4713.rst         |   190 +
>  Documentation/media/v4l-drivers/si476x.rst         |   150 +
>  .../v4l-drivers/soc-camera.rst}                    |    41 +-
>  .../media/v4l-drivers/tm6000-cardlist.rst          |    21 +
>  Documentation/media/v4l-drivers/tuner-cardlist.rst |    96 +
>  Documentation/media/v4l-drivers/tuners.rst         |   131 +
>  .../media/v4l-drivers/usbvision-cardlist.rst       |    72 +
>  .../v4l-drivers/uvcvideo.rst}                      |    48 +-
>  Documentation/media/v4l-drivers/v4l-with-ir.rst    |    73 +
>  .../vivid.txt => media/v4l-drivers/vivid.rst}      |   667 +-
>  .../Zoran => media/v4l-drivers/zoran.rst}          |   307 +-
>  .../zr364xx.txt => media/v4l-drivers/zr364xx.rst}  |    89 +-
>  Documentation/media/video.h.rst.exceptions         |    40 +
>  Documentation/media/videodev2.h.rst.exceptions     |   535 +
>  Documentation/sphinx-static/theme_overrides.css    |    58 +
>  Documentation/sphinx/kernel_include.py             |   183 +
>  Documentation/sphinx/parse-headers.pl              |   321 +
>  Documentation/video4linux/API.html                 |    27 -
>  Documentation/video4linux/CARDLIST.au0828          |     6 -
>  Documentation/video4linux/CARDLIST.bttv            |   167 -
>  Documentation/video4linux/CARDLIST.cx23885         |    57 -
>  Documentation/video4linux/CARDLIST.cx88            |    91 -
>  Documentation/video4linux/CARDLIST.em28xx          |   100 -
>  Documentation/video4linux/CARDLIST.ivtv            |    24 -
>  Documentation/video4linux/CARDLIST.saa7134         |   197 -
>  Documentation/video4linux/CARDLIST.saa7164         |    14 -
>  Documentation/video4linux/CARDLIST.tm6000          |    16 -
>  Documentation/video4linux/CARDLIST.tuner           |    91 -
>  Documentation/video4linux/CARDLIST.usbvision       |    67 -
>  Documentation/video4linux/README.cpia2             |   130 -
>  Documentation/video4linux/README.cx88              |    67 -
>  Documentation/video4linux/README.ir                |    72 -
>  Documentation/video4linux/README.ivtv              |   186 -
>  Documentation/video4linux/README.saa7134           |    82 -
>  Documentation/video4linux/bttv/CONTRIBUTORS        |    25 -
>  Documentation/video4linux/bttv/Cards               |   960 --
>  Documentation/video4linux/bttv/ICs                 |    37 -
>  Documentation/video4linux/bttv/Insmod-options      |   172 -
>  Documentation/video4linux/bttv/MAKEDEV             |    27 -
>  Documentation/video4linux/bttv/Modprobe.conf       |    11 -
>  Documentation/video4linux/bttv/Modules.conf        |    14 -
>  Documentation/video4linux/bttv/PROBLEMS            |    62 -
>  Documentation/video4linux/bttv/README              |    90 -
>  Documentation/video4linux/bttv/README.WINVIEW      |    33 -
>  Documentation/video4linux/bttv/README.freeze       |    74 -
>  Documentation/video4linux/bttv/README.quirks       |    83 -
>  Documentation/video4linux/bttv/Sound-FAQ           |   148 -
>  Documentation/video4linux/bttv/Specs               |     3 -
>  Documentation/video4linux/bttv/THANKS              |    24 -
>  Documentation/video4linux/bttv/Tuners              |   115 -
>  Documentation/video4linux/cpia2_overview.txt       |    38 -
>  Documentation/video4linux/cx2341x/README.hm12      |   120 -
>  Documentation/video4linux/cx2341x/README.vbi       |    45 -
>  Documentation/video4linux/cx2341x/fw-calling.txt   |    69 -
>  .../video4linux/cx2341x/fw-decoder-api.txt         |   297 -
>  .../video4linux/cx2341x/fw-decoder-regs.txt        |   817 --
>  Documentation/video4linux/cx2341x/fw-dma.txt       |    96 -
>  .../video4linux/cx2341x/fw-encoder-api.txt         |   709 --
>  Documentation/video4linux/cx2341x/fw-memory.txt    |   139 -
>  Documentation/video4linux/cx2341x/fw-osd-api.txt   |   350 -
>  Documentation/video4linux/cx2341x/fw-upload.txt    |    49 -
>  .../video4linux/cx88/hauppauge-wintv-cx88-ir.txt   |    54 -
>  .../video4linux/hauppauge-wintv-cx88-ir.txt        |    54 -
>  Documentation/video4linux/lifeview.txt             |    42 -
>  .../video4linux/not-in-cx2388x-datasheet.txt       |    41 -
>  Documentation/video4linux/pxa_camera.txt           |   174 -
>  Documentation/video4linux/radiotrack.txt           |   147 -
>  Documentation/video4linux/si4713.txt               |   176 -
>  Documentation/video4linux/si476x.txt               |   187 -
>  Documentation/video4linux/v4l2-framework.txt       |  1160 --
>  drivers/media/dvb-core/demux.h                     |   165 +-
>  drivers/media/dvb-core/dvb_frontend.h              |    53 +-
>  drivers/media/dvb-core/dvb_math.h                  |     7 +
>  drivers/media/dvb-core/dvb_ringbuffer.h            |    15 +-
>  drivers/media/v4l2-core/v4l2-dev.c                 |    34 -
>  drivers/media/v4l2-core/v4l2-subdev.c              |    10 -
>  include/media/lirc_dev.h                           |     2 +-
>  include/media/media-device.h                       |   255 +-
>  include/media/media-entity.h                       |    89 +-
>  include/media/rc-core.h                            |    45 +-
>  include/media/rc-map.h                             |    17 +-
>  include/media/tuner-types.h                        |     8 +-
>  include/media/tveeprom.h                           |    18 +-
>  include/media/v4l2-async.h                         |    39 +
>  include/media/v4l2-common.h                        |    92 +-
>  include/media/v4l2-ctrls.h                         |   369 +-
>  include/media/v4l2-dev.h                           |   364 +-
>  include/media/v4l2-device.h                        |   198 +-
>  include/media/v4l2-dv-timings.h                    |     2 +-
>  include/media/v4l2-event.h                         |   125 +-
>  include/media/v4l2-fh.h                            |   128 +-
>  include/media/v4l2-ioctl.h                         |   266 +
>  include/media/v4l2-mc.h                            |    13 +-
>  include/media/v4l2-subdev.h                        |   576 +-
>  include/media/videobuf2-core.h                     |    74 +-
>  include/uapi/linux/lirc.h                          |    39 +-
>  .../video4linux => scripts}/extract_xc3028.pl      |     0
>  {Documentation/dvb => scripts}/get_dvb_firmware    |     0
>  619 files changed, 88276 insertions(+), 10988 deletions(-)
>  delete mode 100644 Documentation/dvb/README.dvb-usb
>  delete mode 100644 Documentation/dvb/avermedia.txt
>  delete mode 100644 Documentation/dvb/bt8xx.txt
>  delete mode 100644 Documentation/dvb/contributors.txt
>  delete mode 100644 Documentation/dvb/readme.txt
>  delete mode 100644 Documentation/dvb/technisat.txt
>  delete mode 100644 Documentation/dvb/ttusb-dec.txt
>  create mode 100644 Documentation/media/Makefile
>  create mode 100644 Documentation/media/audio.h.rst.exceptions
>  create mode 100644 Documentation/media/ca.h.rst.exceptions
>  create mode 100644 Documentation/media/cec.h.rst.exceptions
>  create mode 100644 Documentation/media/dmx.h.rst.exceptions
>  create mode 100644 Documentation/media/dvb-drivers/avermedia.rst
>  create mode 100644 Documentation/media/dvb-drivers/bt8xx.rst
>  rename Documentation/{dvb/cards.txt => media/dvb-drivers/cards.rst} (69%)
>  rename Documentation/{dvb/ci.txt => media/dvb-drivers/ci.rst} (53%)
>  create mode 100644 Documentation/media/dvb-drivers/contributors.rst
>  create mode 100644 Documentation/media/dvb-drivers/dvb-usb.rst
>  rename Documentation/{dvb/faq.txt => media/dvb-drivers/faq.rst} (95%)
>  create mode 100644 Documentation/media/dvb-drivers/index.rst
>  create mode 100644 Documentation/media/dvb-drivers/intro.rst
>  rename Documentation/{dvb/lmedm04.txt => media/dvb-drivers/lmedm04.rst} (50%)
>  rename Documentation/{dvb/opera-firmware.txt => media/dvb-drivers/opera-firmware.rst} (74%)
>  create mode 100644 Documentation/media/dvb-drivers/technisat.rst
>  create mode 100644 Documentation/media/dvb-drivers/ttusb-dec.rst
>  rename Documentation/{dvb/udev.txt => media/dvb-drivers/udev.rst} (72%)
>  create mode 100644 Documentation/media/frontend.h.rst.exceptions
>  create mode 100644 Documentation/media/intro.rst
>  create mode 100644 Documentation/media/kapi/dtv-core.rst
>  create mode 100644 Documentation/media/kapi/mc-core.rst
>  create mode 100644 Documentation/media/kapi/rc-core.rst
>  create mode 100644 Documentation/media/kapi/v4l2-clocks.rst
>  create mode 100644 Documentation/media/kapi/v4l2-common.rst
>  rename Documentation/{video4linux/v4l2-controls.txt => media/kapi/v4l2-controls.rst} (91%)
>  create mode 100644 Documentation/media/kapi/v4l2-core.rst
>  create mode 100644 Documentation/media/kapi/v4l2-dev.rst
>  create mode 100644 Documentation/media/kapi/v4l2-device.rst
>  create mode 100644 Documentation/media/kapi/v4l2-dv-timings.rst
>  create mode 100644 Documentation/media/kapi/v4l2-event.rst
>  create mode 100644 Documentation/media/kapi/v4l2-fh.rst
>  create mode 100644 Documentation/media/kapi/v4l2-flash-led-class.rst
>  create mode 100644 Documentation/media/kapi/v4l2-intro.rst
>  create mode 100644 Documentation/media/kapi/v4l2-mc.rst
>  create mode 100644 Documentation/media/kapi/v4l2-mediabus.rst
>  create mode 100644 Documentation/media/kapi/v4l2-mem2mem.rst
>  create mode 100644 Documentation/media/kapi/v4l2-of.rst
>  create mode 100644 Documentation/media/kapi/v4l2-rect.rst
>  create mode 100644 Documentation/media/kapi/v4l2-subdev.rst
>  create mode 100644 Documentation/media/kapi/v4l2-tuner.rst
>  create mode 100644 Documentation/media/kapi/v4l2-tveeprom.rst
>  rename Documentation/{video4linux/videobuf => media/kapi/v4l2-videobuf.rst} (95%)
>  create mode 100644 Documentation/media/kapi/v4l2-videobuf2.rst
>  create mode 100644 Documentation/media/lirc.h.rst.exceptions
>  create mode 100644 Documentation/media/media.h.rst.exceptions
>  create mode 100644 Documentation/media/media_api_files/typical_media_device.pdf
>  create mode 100644 Documentation/media/media_api_files/typical_media_device.svg
>  create mode 100644 Documentation/media/media_kapi.rst
>  create mode 100644 Documentation/media/media_uapi.rst
>  create mode 100644 Documentation/media/net.h.rst.exceptions
>  create mode 100644 Documentation/media/uapi/cec/cec-api.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-func-close.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-func-ioctl.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-func-open.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-func-poll.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-funcs.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-header.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-intro.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-ioc-dqevent.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-ioc-g-mode.rst
>  create mode 100644 Documentation/media/uapi/cec/cec-ioc-receive.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-channel-select.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-clear-buffer.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-continue.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-fclose.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-fopen.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-fwrite.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-get-capabilities.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-get-pts.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-get-status.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-pause.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-play.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-select-source.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-set-attributes.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-set-av-sync.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-set-ext-id.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-set-id.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-set-karaoke.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-set-mixer.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-set-mute.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-set-streamtype.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio-stop.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio_data_types.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio_function_calls.rst
>  create mode 100644 Documentation/media/uapi/dvb/audio_h.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca-fclose.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca-fopen.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca-get-cap.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca-get-descr-info.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca-get-msg.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca-get-slot-info.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca-reset.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca-send-msg.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca-set-descr.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca-set-pid.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca_data_types.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca_function_calls.rst
>  create mode 100644 Documentation/media/uapi/dvb/ca_h.rst
>  create mode 100644 Documentation/media/uapi/dvb/demux.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-add-pid.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-fclose.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-fopen.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-fread.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-fwrite.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-get-caps.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-get-event.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-get-stc.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-remove-pid.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-set-filter.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-set-source.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-start.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx-stop.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx_fcalls.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx_h.rst
>  create mode 100644 Documentation/media/uapi/dvb/dmx_types.rst
>  create mode 100644 Documentation/media/uapi/dvb/dtv-fe-stats.rst
>  create mode 100644 Documentation/media/uapi/dvb/dtv-properties.rst
>  create mode 100644 Documentation/media/uapi/dvb/dtv-property.rst
>  create mode 100644 Documentation/media/uapi/dvb/dtv-stats.rst
>  create mode 100644 Documentation/media/uapi/dvb/dvb-fe-read-status.rst
>  create mode 100644 Documentation/media/uapi/dvb/dvb-frontend-event.rst
>  create mode 100644 Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
>  create mode 100644 Documentation/media/uapi/dvb/dvbapi.rst
>  create mode 100644 Documentation/media/uapi/dvb/dvbproperty-006.rst
>  create mode 100644 Documentation/media/uapi/dvb/dvbproperty.rst
>  create mode 100644 Documentation/media/uapi/dvb/examples.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-bandwidth-t.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-get-event.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-get-frontend.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-get-info.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-get-property.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-read-ber.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-read-signal-strength.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-read-snr.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-read-status.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-set-frontend.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-set-tone.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-set-voltage.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe-type-t.rst
>  create mode 100644 Documentation/media/uapi/dvb/fe_property_parameters.rst
>  create mode 100644 Documentation/media/uapi/dvb/frontend-property-cable-systems.rst
>  create mode 100644 Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
>  create mode 100644 Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst
>  create mode 100644 Documentation/media/uapi/dvb/frontend-stat-properties.rst
>  create mode 100644 Documentation/media/uapi/dvb/frontend.rst
>  create mode 100644 Documentation/media/uapi/dvb/frontend_f_close.rst
>  create mode 100644 Documentation/media/uapi/dvb/frontend_f_open.rst
>  create mode 100644 Documentation/media/uapi/dvb/frontend_fcalls.rst
>  create mode 100644 Documentation/media/uapi/dvb/frontend_h.rst
>  create mode 100644 Documentation/media/uapi/dvb/frontend_legacy_api.rst
>  create mode 100644 Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
>  create mode 100644 Documentation/media/uapi/dvb/intro.rst
>  create mode 100644 Documentation/media/uapi/dvb/intro_files/dvbstb.pdf
>  create mode 100644 Documentation/media/uapi/dvb/intro_files/dvbstb.png
>  create mode 100644 Documentation/media/uapi/dvb/legacy_dvb_apis.rst
>  create mode 100644 Documentation/media/uapi/dvb/net-add-if.rst
>  create mode 100644 Documentation/media/uapi/dvb/net-get-if.rst
>  create mode 100644 Documentation/media/uapi/dvb/net-remove-if.rst
>  create mode 100644 Documentation/media/uapi/dvb/net.rst
>  create mode 100644 Documentation/media/uapi/dvb/net_h.rst
>  create mode 100644 Documentation/media/uapi/dvb/query-dvb-frontend-info.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-clear-buffer.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-command.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-continue.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-fast-forward.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-fclose.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-fopen.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-freeze.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-fwrite.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-get-capabilities.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-get-event.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-get-frame-count.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-get-frame-rate.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-get-navi.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-get-pts.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-get-size.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-get-status.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-play.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-select-source.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-set-attributes.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-set-blank.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-set-display-format.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-set-format.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-set-highlight.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-set-id.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-set-spu-palette.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-set-spu.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-set-streamtype.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-set-system.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-slowmotion.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-stillpicture.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-stop.rst
>  create mode 100644 Documentation/media/uapi/dvb/video-try-command.rst
>  create mode 100644 Documentation/media/uapi/dvb/video.rst
>  create mode 100644 Documentation/media/uapi/dvb/video_function_calls.rst
>  create mode 100644 Documentation/media/uapi/dvb/video_h.rst
>  create mode 100644 Documentation/media/uapi/dvb/video_types.rst
>  create mode 100644 Documentation/media/uapi/fdl-appendix.rst
>  create mode 100644 Documentation/media/uapi/gen-errors.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-controller-intro.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-controller-model.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-controller.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-func-close.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-func-ioctl.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-func-open.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-funcs.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-header.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-ioc-device-info.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-types.rst
>  create mode 100644 Documentation/media/uapi/rc/keytable.c.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-dev-intro.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-dev.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-func.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-get-features.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-get-length.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-get-rec-mode.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-get-send-mode.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-get-timeout.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-header.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-read.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-set-send-carrier.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
>  create mode 100644 Documentation/media/uapi/rc/lirc-write.rst
>  create mode 100644 Documentation/media/uapi/rc/rc-intro.rst
>  create mode 100644 Documentation/media/uapi/rc/rc-sysfs-nodes.rst
>  create mode 100644 Documentation/media/uapi/rc/rc-table-change.rst
>  create mode 100644 Documentation/media/uapi/rc/rc-tables.rst
>  create mode 100644 Documentation/media/uapi/rc/remote_controllers.rst
>  create mode 100644 Documentation/media/uapi/v4l/app-pri.rst
>  create mode 100644 Documentation/media/uapi/v4l/async.rst
>  create mode 100644 Documentation/media/uapi/v4l/audio.rst
>  create mode 100644 Documentation/media/uapi/v4l/biblio.rst
>  create mode 100644 Documentation/media/uapi/v4l/buffer.rst
>  create mode 100644 Documentation/media/uapi/v4l/capture-example.rst
>  create mode 100644 Documentation/media/uapi/v4l/capture.c.rst
>  create mode 100644 Documentation/media/uapi/v4l/colorspaces.rst
>  create mode 100644 Documentation/media/uapi/v4l/common-defs.rst
>  create mode 100644 Documentation/media/uapi/v4l/common.rst
>  create mode 100644 Documentation/media/uapi/v4l/compat.rst
>  create mode 100644 Documentation/media/uapi/v4l/control.rst
>  create mode 100644 Documentation/media/uapi/v4l/crop.rst
>  create mode 100644 Documentation/media/uapi/v4l/crop_files/crop.gif
>  create mode 100644 Documentation/media/uapi/v4l/crop_files/crop.pdf
>  create mode 100644 Documentation/media/uapi/v4l/depth-formats.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-capture.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-codec.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-effect.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-event.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-osd.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-output.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-overlay.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-radio.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-raw-vbi.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_525.gif
>  create mode 100644 Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_525.pdf
>  create mode 100644 Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.gif
>  create mode 100644 Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf
>  create mode 100644 Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_hsync.gif
>  create mode 100644 Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_hsync.pdf
>  create mode 100644 Documentation/media/uapi/v4l/dev-rds.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-sdr.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-sliced-vbi.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-subdev.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-subdev_files/pipeline.pdf
>  create mode 100644 Documentation/media/uapi/v4l/dev-subdev_files/pipeline.png
>  create mode 100644 Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-crop.pdf
>  create mode 100644 Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-crop.svg
>  create mode 100644 Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-full.pdf
>  create mode 100644 Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-full.svg
>  create mode 100644 Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.pdf
>  create mode 100644 Documentation/media/uapi/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg
>  create mode 100644 Documentation/media/uapi/v4l/dev-teletext.rst
>  create mode 100644 Documentation/media/uapi/v4l/devices.rst
>  create mode 100644 Documentation/media/uapi/v4l/diff-v4l.rst
>  create mode 100644 Documentation/media/uapi/v4l/dmabuf.rst
>  create mode 100644 Documentation/media/uapi/v4l/driver.rst
>  create mode 100644 Documentation/media/uapi/v4l/dv-timings.rst
>  create mode 100644 Documentation/media/uapi/v4l/extended-controls.rst
>  create mode 100644 Documentation/media/uapi/v4l/field-order.rst
>  create mode 100644 Documentation/media/uapi/v4l/field-order_files/fieldseq_bt.gif
>  create mode 100644 Documentation/media/uapi/v4l/field-order_files/fieldseq_bt.pdf
>  create mode 100644 Documentation/media/uapi/v4l/field-order_files/fieldseq_tb.gif
>  create mode 100644 Documentation/media/uapi/v4l/field-order_files/fieldseq_tb.pdf
>  create mode 100644 Documentation/media/uapi/v4l/format.rst
>  create mode 100644 Documentation/media/uapi/v4l/func-close.rst
>  create mode 100644 Documentation/media/uapi/v4l/func-ioctl.rst
>  create mode 100644 Documentation/media/uapi/v4l/func-mmap.rst
>  create mode 100644 Documentation/media/uapi/v4l/func-munmap.rst
>  create mode 100644 Documentation/media/uapi/v4l/func-open.rst
>  create mode 100644 Documentation/media/uapi/v4l/func-poll.rst
>  create mode 100644 Documentation/media/uapi/v4l/func-read.rst
>  create mode 100644 Documentation/media/uapi/v4l/func-select.rst
>  create mode 100644 Documentation/media/uapi/v4l/func-write.rst
>  create mode 100644 Documentation/media/uapi/v4l/hist-v4l2.rst
>  create mode 100644 Documentation/media/uapi/v4l/io.rst
>  create mode 100644 Documentation/media/uapi/v4l/libv4l-introduction.rst
>  create mode 100644 Documentation/media/uapi/v4l/libv4l.rst
>  create mode 100644 Documentation/media/uapi/v4l/mmap.rst
>  create mode 100644 Documentation/media/uapi/v4l/open.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-002.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-003.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-004.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-006.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-007.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-008.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-013.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-grey.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-indexed.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-m420.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12m.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.gif
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv16.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv16m.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv24.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-reserved.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-rgb.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10dpcm8.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb12.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb8.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-uv8.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-uyvy.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-vyuy.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-y10.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-y10b.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-y12.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-y12i.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-y16-be.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-y16.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-y41p.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-y8i.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-yuv410.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-yuv420.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-yuyv.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-yvyu.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-z16.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt.rst
>  create mode 100644 Documentation/media/uapi/v4l/planar-apis.rst
>  create mode 100644 Documentation/media/uapi/v4l/querycap.rst
>  create mode 100644 Documentation/media/uapi/v4l/rw.rst
>  create mode 100644 Documentation/media/uapi/v4l/sdr-formats.rst
>  create mode 100644 Documentation/media/uapi/v4l/selection-api-002.rst
>  create mode 100644 Documentation/media/uapi/v4l/selection-api-003.rst
>  create mode 100644 Documentation/media/uapi/v4l/selection-api-003_files/selection.png
>  create mode 100644 Documentation/media/uapi/v4l/selection-api-004.rst
>  create mode 100644 Documentation/media/uapi/v4l/selection-api-005.rst
>  create mode 100644 Documentation/media/uapi/v4l/selection-api-006.rst
>  create mode 100644 Documentation/media/uapi/v4l/selection-api.rst
>  create mode 100644 Documentation/media/uapi/v4l/selections-common.rst
>  create mode 100644 Documentation/media/uapi/v4l/standard.rst
>  create mode 100644 Documentation/media/uapi/v4l/streaming-par.rst
>  create mode 100644 Documentation/media/uapi/v4l/subdev-formats.rst
>  create mode 100644 Documentation/media/uapi/v4l/subdev-formats_files/bayer.png
>  create mode 100644 Documentation/media/uapi/v4l/tuner.rst
>  create mode 100644 Documentation/media/uapi/v4l/user-func.rst
>  create mode 100644 Documentation/media/uapi/v4l/userp.rst
>  create mode 100644 Documentation/media/uapi/v4l/v4l2-selection-flags.rst
>  create mode 100644 Documentation/media/uapi/v4l/v4l2-selection-targets.rst
>  create mode 100644 Documentation/media/uapi/v4l/v4l2.rst
>  create mode 100644 Documentation/media/uapi/v4l/v4l2grab-example.rst
>  create mode 100644 Documentation/media/uapi/v4l/v4l2grab.c.rst
>  create mode 100644 Documentation/media/uapi/v4l/video.rst
>  create mode 100644 Documentation/media/uapi/v4l/videodev.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-create-bufs.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-cropcap.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-dqevent.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-enumaudio.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-enuminput.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-enumoutput.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-enumstd.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-expbuf.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-audio.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-audioout.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-crop.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-edid.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-fmt.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-frequency.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-input.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-modulator.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-output.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-parm.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-priority.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-selection.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-selection_files/constraints.png
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-std.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-g-tuner.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-log-status.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-overlay.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-qbuf.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-querybuf.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-querycap.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-queryctrl.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-querystd.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-reqbufs.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-streamon.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
>  create mode 100644 Documentation/media/uapi/v4l/yuv-formats.rst
>  create mode 100644 Documentation/media/v4l-drivers/au0828-cardlist.rst
>  create mode 100644 Documentation/media/v4l-drivers/bttv-cardlist.rst
>  create mode 100644 Documentation/media/v4l-drivers/bttv.rst
>  rename Documentation/{video4linux/cafe_ccic => media/v4l-drivers/cafe_ccic.rst} (87%)
>  create mode 100644 Documentation/media/v4l-drivers/cardlist.rst
>  create mode 100644 Documentation/media/v4l-drivers/cpia2.rst
>  rename Documentation/{video4linux/cx18.txt => media/v4l-drivers/cx18.rst} (91%)
>  create mode 100644 Documentation/media/v4l-drivers/cx2341x.rst
>  create mode 100644 Documentation/media/v4l-drivers/cx23885-cardlist.rst
>  create mode 100644 Documentation/media/v4l-drivers/cx88-cardlist.rst
>  create mode 100644 Documentation/media/v4l-drivers/cx88.rst
>  rename Documentation/{video4linux/README.davinci-vpbe => media/v4l-drivers/davinci-vpbe.rst} (86%)
>  create mode 100644 Documentation/media/v4l-drivers/em28xx-cardlist.rst
>  rename Documentation/{video4linux/fimc.txt => media/v4l-drivers/fimc.rst} (71%)
>  rename Documentation/{video4linux/4CCs.txt => media/v4l-drivers/fourcc.rst} (80%)
>  rename Documentation/{video4linux/gspca.txt => media/v4l-drivers/gspca-cardlist.rst} (97%)
>  create mode 100644 Documentation/media/v4l-drivers/index.rst
>  create mode 100644 Documentation/media/v4l-drivers/ivtv-cardlist.rst
>  create mode 100644 Documentation/media/v4l-drivers/ivtv.rst
>  rename Documentation/{video4linux/meye.txt => media/v4l-drivers/meye.rst} (52%)
>  rename Documentation/{video4linux/omap3isp.txt => media/v4l-drivers/omap3isp.rst} (81%)
>  rename Documentation/{video4linux/omap4_camera.txt => media/v4l-drivers/omap4_camera.rst} (66%)
>  rename Documentation/{video4linux/README.pvrusb2 => media/v4l-drivers/pvrusb2.rst} (53%)
>  create mode 100644 Documentation/media/v4l-drivers/pxa_camera.rst
>  create mode 100644 Documentation/media/v4l-drivers/radiotrack.rst
>  create mode 100644 Documentation/media/v4l-drivers/saa7134-cardlist.rst
>  create mode 100644 Documentation/media/v4l-drivers/saa7134.rst
>  create mode 100644 Documentation/media/v4l-drivers/saa7164-cardlist.rst
>  rename Documentation/{video4linux/sh_mobile_ceu_camera.txt => media/v4l-drivers/sh_mobile_ceu_camera.rst} (85%)
>  rename Documentation/{video4linux/si470x.txt => media/v4l-drivers/si470x.rst} (82%)
>  create mode 100644 Documentation/media/v4l-drivers/si4713.rst
>  create mode 100644 Documentation/media/v4l-drivers/si476x.rst
>  rename Documentation/{video4linux/soc-camera.txt => media/v4l-drivers/soc-camera.rst} (92%)
>  create mode 100644 Documentation/media/v4l-drivers/tm6000-cardlist.rst
>  create mode 100644 Documentation/media/v4l-drivers/tuner-cardlist.rst
>  create mode 100644 Documentation/media/v4l-drivers/tuners.rst
>  create mode 100644 Documentation/media/v4l-drivers/usbvision-cardlist.rst
>  rename Documentation/{video4linux/uvcvideo.txt => media/v4l-drivers/uvcvideo.rst} (93%)
>  create mode 100644 Documentation/media/v4l-drivers/v4l-with-ir.rst
>  rename Documentation/{video4linux/vivid.txt => media/v4l-drivers/vivid.rst} (77%)
>  rename Documentation/{video4linux/Zoran => media/v4l-drivers/zoran.rst} (78%)
>  rename Documentation/{video4linux/zr364xx.txt => media/v4l-drivers/zr364xx.rst} (66%)
>  create mode 100644 Documentation/media/video.h.rst.exceptions
>  create mode 100644 Documentation/media/videodev2.h.rst.exceptions
>  create mode 100644 Documentation/sphinx-static/theme_overrides.css
>  create mode 100755 Documentation/sphinx/kernel_include.py
>  create mode 100755 Documentation/sphinx/parse-headers.pl
>  delete mode 100644 Documentation/video4linux/API.html
>  delete mode 100644 Documentation/video4linux/CARDLIST.au0828
>  delete mode 100644 Documentation/video4linux/CARDLIST.bttv
>  delete mode 100644 Documentation/video4linux/CARDLIST.cx23885
>  delete mode 100644 Documentation/video4linux/CARDLIST.cx88
>  delete mode 100644 Documentation/video4linux/CARDLIST.em28xx
>  delete mode 100644 Documentation/video4linux/CARDLIST.ivtv
>  delete mode 100644 Documentation/video4linux/CARDLIST.saa7134
>  delete mode 100644 Documentation/video4linux/CARDLIST.saa7164
>  delete mode 100644 Documentation/video4linux/CARDLIST.tm6000
>  delete mode 100644 Documentation/video4linux/CARDLIST.tuner
>  delete mode 100644 Documentation/video4linux/CARDLIST.usbvision
>  delete mode 100644 Documentation/video4linux/README.cpia2
>  delete mode 100644 Documentation/video4linux/README.cx88
>  delete mode 100644 Documentation/video4linux/README.ir
>  delete mode 100644 Documentation/video4linux/README.ivtv
>  delete mode 100644 Documentation/video4linux/README.saa7134
>  delete mode 100644 Documentation/video4linux/bttv/CONTRIBUTORS
>  delete mode 100644 Documentation/video4linux/bttv/Cards
>  delete mode 100644 Documentation/video4linux/bttv/ICs
>  delete mode 100644 Documentation/video4linux/bttv/Insmod-options
>  delete mode 100644 Documentation/video4linux/bttv/MAKEDEV
>  delete mode 100644 Documentation/video4linux/bttv/Modprobe.conf
>  delete mode 100644 Documentation/video4linux/bttv/Modules.conf
>  delete mode 100644 Documentation/video4linux/bttv/PROBLEMS
>  delete mode 100644 Documentation/video4linux/bttv/README
>  delete mode 100644 Documentation/video4linux/bttv/README.WINVIEW
>  delete mode 100644 Documentation/video4linux/bttv/README.freeze
>  delete mode 100644 Documentation/video4linux/bttv/README.quirks
>  delete mode 100644 Documentation/video4linux/bttv/Sound-FAQ
>  delete mode 100644 Documentation/video4linux/bttv/Specs
>  delete mode 100644 Documentation/video4linux/bttv/THANKS
>  delete mode 100644 Documentation/video4linux/bttv/Tuners
>  delete mode 100644 Documentation/video4linux/cpia2_overview.txt
>  delete mode 100644 Documentation/video4linux/cx2341x/README.hm12
>  delete mode 100644 Documentation/video4linux/cx2341x/README.vbi
>  delete mode 100644 Documentation/video4linux/cx2341x/fw-calling.txt
>  delete mode 100644 Documentation/video4linux/cx2341x/fw-decoder-api.txt
>  delete mode 100644 Documentation/video4linux/cx2341x/fw-decoder-regs.txt
>  delete mode 100644 Documentation/video4linux/cx2341x/fw-dma.txt
>  delete mode 100644 Documentation/video4linux/cx2341x/fw-encoder-api.txt
>  delete mode 100644 Documentation/video4linux/cx2341x/fw-memory.txt
>  delete mode 100644 Documentation/video4linux/cx2341x/fw-osd-api.txt
>  delete mode 100644 Documentation/video4linux/cx2341x/fw-upload.txt
>  delete mode 100644 Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
>  delete mode 100644 Documentation/video4linux/hauppauge-wintv-cx88-ir.txt
>  delete mode 100644 Documentation/video4linux/lifeview.txt
>  delete mode 100644 Documentation/video4linux/not-in-cx2388x-datasheet.txt
>  delete mode 100644 Documentation/video4linux/pxa_camera.txt
>  delete mode 100644 Documentation/video4linux/radiotrack.txt
>  delete mode 100644 Documentation/video4linux/si4713.txt
>  delete mode 100644 Documentation/video4linux/si476x.txt
>  delete mode 100644 Documentation/video4linux/v4l2-framework.txt
>  rename {Documentation/video4linux => scripts}/extract_xc3028.pl (100%)
>  rename {Documentation/dvb => scripts}/get_dvb_firmware (100%)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
