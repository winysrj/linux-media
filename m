Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbcGHND7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:03:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/54] Second series of ReST convert patches for media
Date: Fri,  8 Jul 2016 10:02:52 -0300
Message-Id: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That's the second series of patches related to DocBook to ReST
conversion. With this patch series, we're ready to merge it
upstream.

There are still one thing to do: there are some new updates at
the DocBook pages on two topic branches (cec and vsp1). Those
changes should also be converted, in order to be able to remove
the DocBook pages.

Visually, I'm more happy with the new pages, as the produced
layout is more fancy, IMHO, using a modern visual.

Also, editing ReST pages is a way simpler than editing the
DocBooks. Also, reviewing documentation patches should be
simpler, with is a good thing.

On the bad side, Sphinx doesn't support auto-numberating
examples, figures or tables. We'll need some extension for
that. For now, the only impact is on the examples, that were
manually numerated. So, patches adding new examples will need
to check and manually renumerate other examples.

I hope we'll have soon some Sphinx extension to support
auto-numbering.

I'll soon change linux.org documentation page to show the
Sphinx-generated documenation. I intend to keep the old
one for a while, for people to be able to compare both.
I'll post an email once I do this at both linux-media and
linux-doc mailing lists.

I did a review on all pages, but, as I'm not a Vulcan,
I'm pretty sure I missed some things. So, feel free to
review the final document and send me patches with any
needed fixes or improvements.

Finally, you'll see some warnings produced by generating
the documentation.

There are actually two types of warnings there:

1) At least here where I sit, I'm getting those warnings:

Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst:18: WARNING: Error when parsing function declaration:
If no return type {
Invalid definition: Expected identifier in nested name, got keyword: int [error at 3]
  int ioctl( int fd, int request, enum fe_sec_mini_cmd *tone )
  ---^
} else if return type {
Invalid definition: Expected identifier in nested name, got keyword: enum [error at 36]
  int ioctl( int fd, int request, enum fe_sec_mini_cmd *tone )
  ------------------------------------^
}

It seems that the cpp:function:: parser on Sphinx doesn't
know how to handle enums. I'll try to woraround this issue later.

2) Undefined label warnings.

This is actually some gaps that I detected when comparing
what's documented with what's there at videodev2.h:
	Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-ycbcr-encoding-fixme (if the link has no caption the label must precede a section header)
	Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-ycbcr-encoding-fixme (if the link has no caption the label must precede a section header)
	Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-ycbcr-encoding-fixme (if the link has no caption the label must precede a section header)
	Documentation/output/videodev2.h.rst:6: WARNING: undefined label: buffer-flags-fixme (if the link has no caption the label must precede a section header)
	Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-dv-fixme (if the link has no caption the label must precede a section header)
	Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-dv-fixme (if the link has no caption the label must precede a section header)


Those are things that we need to fix by either documenting
some things or by removing/deprecating some old/unused stuff.

Markus Heiser (6):
  doc-rst: boilerplate HTML theme customization
  doc-rst: customize RTD theme, table & full width
  doc-rst: customize RTD theme, captions & inline literal
  doc-rst: auto-generate: fixed include "output/*.h.rst" content
  doc-rst: add kernel-include directive
  doc-rst: linux_tv/Makefile: Honor quiet make O=dir

Mauro Carvalho Chehab (48):
  doc-rst: linux_tv: split DVB function call documentation
  doc-rst: linux_tv: reformat all syscall pages
  doc-rst: linux_tv: dvb: use lowercase for filenames
  doc-rst: linux_tv: dvb: put return value at the end
  doc-rst: remove Documentation/linux_tv/conf.py file
  doc-rst: linux_tv: don't use uppercases for syscall sections
  doc-rst: linux_tv: use :cpp:function:: on all syscalls
  doc-rst: dmabuf: Fix the cross-reference
  doc-rst: dev-overlay: fix the last warning
  doc-rst: dvbapi: Fix conversion issues
  doc-rst: fix intro_files/dvbstb.png image
  doc-rst: dvb/intro: Better show the needed include blocks
  doc-rst: intro: remove obsolete headers
  doc-rst: media-controller: fix conversion issues
  doc-rst: media-controller: missing credits
  doc-rst: media-controller.rst: add missing copy symbol
  doc-rst: media-controller-model: fix a typo
  doc-rst: mediactl: fix some wrong cross references
  doc-rst: media-ioc-g-topology: Fix tables
  doc-rst: media-ioc-enum-entities: better format the table
  doc-rst: gen-errors: Improve table layout
  doc-rst: remote_controllers: fix conversion issues
  doc-rst: Rename the title of the Digital TV section
  doc-rst: v4l2: Rename the V4L2 API title
  doc-rst: linux_tv/index: Rename the book name
  doc-rst: add parse-headers.pl script
  doc-rst: auto-build the frontend.h.rst
  doc-rst: parse-headers: improve delimiters to detect symbols
  doc-dst: parse-headers: highlight deprecated comments
  doc-rst: fix parsing comments and '{' on a separate line
  doc-rst: parse-headers: be more formal about the valid symbols
  doc-rst: parse-headers: better handle typedefs
  doc-rst: parse-headers: fix multiline typedef handler
  doc-rst: auto-generate dmx.h.rst
  doc-rst: auto-generate audio.h.rst
  doc-rst: auto-generate ca.h.rst
  doc-rst: auto-generate net.h.rst
  doc-rst: auto-generate video.h.rst
  doc-rst: parse-headers: better handle comments at the source code
  doc-rst: parse-headers: add an option to ignore enum symbols
  doc-rst: parse-headers: don't do substituition references
  doc-rst: autogenerate videodev2.h.rst file
  doc-rst: fix some badly converted references
  doc-rst: linux_tv: Don't ignore pix formats
  doc-rst: videodev2.h: don't ignore V4L2_STD macros
  doc-rst: document enum symbols
  doc-rst: videodev2.h: add cross-references for defines
  doc-rst: linux_tv/Makefile: Honor quiet mode

 Documentation/Makefile.sphinx                      |    3 +-
 Documentation/conf.py                              |   11 +-
 Documentation/linux_tv/Makefile                    |   50 +
 Documentation/linux_tv/audio.h.rst                 |  142 --
 Documentation/linux_tv/audio.h.rst.exceptions      |   20 +
 Documentation/linux_tv/ca.h.rst                    |   97 -
 Documentation/linux_tv/ca.h.rst.exceptions         |   24 +
 Documentation/linux_tv/conf.py                     |  221 --
 Documentation/linux_tv/dmx.h.rst                   |  162 --
 Documentation/linux_tv/dmx.h.rst.exceptions        |   63 +
 Documentation/linux_tv/frontend.h.rst              |  609 ------
 Documentation/linux_tv/frontend.h.rst.exceptions   |   47 +
 Documentation/linux_tv/index.rst                   |    2 +-
 .../media/dvb/audio-bilingual-channel-select.rst   |   64 +
 .../linux_tv/media/dvb/audio-channel-select.rst    |   63 +
 .../linux_tv/media/dvb/audio-clear-buffer.rst      |   54 +
 .../linux_tv/media/dvb/audio-continue.rst          |   54 +
 Documentation/linux_tv/media/dvb/audio-fclose.rst  |   54 +
 Documentation/linux_tv/media/dvb/audio-fopen.rst   |  104 +
 Documentation/linux_tv/media/dvb/audio-fwrite.rst  |   82 +
 .../linux_tv/media/dvb/audio-get-capabilities.rst  |   60 +
 Documentation/linux_tv/media/dvb/audio-get-pts.rst |   69 +
 .../linux_tv/media/dvb/audio-get-status.rst        |   60 +
 Documentation/linux_tv/media/dvb/audio-pause.rst   |   55 +
 Documentation/linux_tv/media/dvb/audio-play.rst    |   54 +
 .../linux_tv/media/dvb/audio-select-source.rst     |   62 +
 .../linux_tv/media/dvb/audio-set-attributes.rst    |   71 +
 .../linux_tv/media/dvb/audio-set-av-sync.rst       |   70 +
 .../linux_tv/media/dvb/audio-set-bypass-mode.rst   |   74 +
 .../linux_tv/media/dvb/audio-set-ext-id.rst        |   71 +
 Documentation/linux_tv/media/dvb/audio-set-id.rst  |   65 +
 .../linux_tv/media/dvb/audio-set-karaoke.rst       |   70 +
 .../linux_tv/media/dvb/audio-set-mixer.rst         |   59 +
 .../linux_tv/media/dvb/audio-set-mute.rst          |   74 +
 .../linux_tv/media/dvb/audio-set-streamtype.rst    |   74 +
 Documentation/linux_tv/media/dvb/audio-stop.rst    |   54 +
 .../linux_tv/media/dvb/audio_function_calls.rst    | 1399 +-----------
 Documentation/linux_tv/media/dvb/audio_h.rst       |    6 +-
 Documentation/linux_tv/media/dvb/ca-fclose.rst     |   54 +
 Documentation/linux_tv/media/dvb/ca-fopen.rst      |  109 +
 Documentation/linux_tv/media/dvb/ca-get-cap.rst    |   59 +
 .../linux_tv/media/dvb/ca-get-descr-info.rst       |   59 +
 Documentation/linux_tv/media/dvb/ca-get-msg.rst    |   59 +
 .../linux_tv/media/dvb/ca-get-slot-info.rst        |   59 +
 Documentation/linux_tv/media/dvb/ca-reset.rst      |   53 +
 Documentation/linux_tv/media/dvb/ca-send-msg.rst   |   59 +
 Documentation/linux_tv/media/dvb/ca-set-descr.rst  |   59 +
 Documentation/linux_tv/media/dvb/ca-set-pid.rst    |   59 +
 .../linux_tv/media/dvb/ca_function_calls.rst       |  577 +----
 Documentation/linux_tv/media/dvb/ca_h.rst          |    6 +-
 Documentation/linux_tv/media/dvb/dmx-add-pid.rst   |   61 +
 Documentation/linux_tv/media/dvb/dmx-fclose.rst    |   55 +
 Documentation/linux_tv/media/dvb/dmx-fopen.rst     |  108 +
 Documentation/linux_tv/media/dvb/dmx-fread.rst     |  108 +
 Documentation/linux_tv/media/dvb/dmx-fwrite.rst    |   89 +
 Documentation/linux_tv/media/dvb/dmx-get-caps.rst  |   59 +
 Documentation/linux_tv/media/dvb/dmx-get-event.rst |   76 +
 .../linux_tv/media/dvb/dmx-get-pes-pids.rst        |   59 +
 Documentation/linux_tv/media/dvb/dmx-get-stc.rst   |   77 +
 .../linux_tv/media/dvb/dmx-remove-pid.rst          |   62 +
 .../linux_tv/media/dvb/dmx-set-buffer-size.rst     |   62 +
 .../linux_tv/media/dvb/dmx-set-filter.rst          |   68 +
 .../linux_tv/media/dvb/dmx-set-pes-filter.rst      |   78 +
 .../linux_tv/media/dvb/dmx-set-source.rst          |   59 +
 Documentation/linux_tv/media/dvb/dmx-start.rst     |   77 +
 Documentation/linux_tv/media/dvb/dmx-stop.rst      |   55 +
 Documentation/linux_tv/media/dvb/dmx_fcalls.rst    | 1075 +--------
 Documentation/linux_tv/media/dvb/dmx_h.rst         |    6 +-
 Documentation/linux_tv/media/dvb/dmx_types.rst     |    8 +-
 Documentation/linux_tv/media/dvb/dvbapi.rst        |   34 +-
 .../linux_tv/media/dvb/fe-bandwidth-t.rst          |   14 +-
 .../media/dvb/fe-diseqc-recv-slave-reply.rst       |   24 +-
 .../media/dvb/fe-diseqc-reset-overload.rst         |   11 +-
 .../linux_tv/media/dvb/fe-diseqc-send-burst.rst    |   28 +-
 .../media/dvb/fe-diseqc-send-master-cmd.rst        |   24 +-
 ..._CMD.rst => fe-dishnetwork-send-legacy-cmd.rst} |   36 +-
 .../media/dvb/fe-enable-high-lnb-voltage.rst       |   11 +-
 .../dvb/{FE_GET_EVENT.rst => fe-get-event.rst}     |   32 +-
 .../{FE_GET_FRONTEND.rst => fe-get-frontend.rst}   |   26 +-
 Documentation/linux_tv/media/dvb/fe-get-info.rst   |   87 +-
 .../linux_tv/media/dvb/fe-get-property.rst         |   12 +-
 .../media/dvb/{FE_READ_BER.rst => fe-read-ber.rst} |   28 +-
 ...AL_STRENGTH.rst => fe-read-signal-strength.rst} |   28 +-
 .../media/dvb/{FE_READ_SNR.rst => fe-read-snr.rst} |   28 +-
 .../linux_tv/media/dvb/fe-read-status.rst          |   35 +-
 ...D_BLOCKS.rst => fe-read-uncorrected-blocks.rst} |   32 +-
 .../media/dvb/fe-set-frontend-tune-mode.rst        |   10 +-
 .../{FE_SET_FRONTEND.rst => fe-set-frontend.rst}   |   42 +-
 Documentation/linux_tv/media/dvb/fe-set-tone.rst   |   28 +-
 .../linux_tv/media/dvb/fe-set-voltage.rst          |   12 +-
 Documentation/linux_tv/media/dvb/fe-type-t.rst     |    8 +-
 .../linux_tv/media/dvb/fe_property_parameters.rst  |  206 +-
 .../linux_tv/media/dvb/frontend_f_close.rst        |    6 +-
 .../linux_tv/media/dvb/frontend_f_open.rst         |    6 +-
 Documentation/linux_tv/media/dvb/frontend_h.rst    |    6 +-
 .../linux_tv/media/dvb/frontend_legacy_api.rst     |   16 +-
 Documentation/linux_tv/media/dvb/intro.rst         |   23 -
 .../linux_tv/media/dvb/intro_files/dvbstb.png      |  Bin 22703 -> 22655 bytes
 Documentation/linux_tv/media/dvb/net-add-if.rst    |   91 +
 Documentation/linux_tv/media/dvb/net-get-if.rst    |   50 +
 Documentation/linux_tv/media/dvb/net-remove-if.rst |   46 +
 Documentation/linux_tv/media/dvb/net.rst           |  180 +-
 Documentation/linux_tv/media/dvb/net_h.rst         |    6 +-
 .../linux_tv/media/dvb/video-clear-buffer.rst      |   54 +
 Documentation/linux_tv/media/dvb/video-command.rst |   66 +
 .../linux_tv/media/dvb/video-continue.rst          |   57 +
 .../linux_tv/media/dvb/video-fast-forward.rst      |   74 +
 Documentation/linux_tv/media/dvb/video-fclose.rst  |   54 +
 Documentation/linux_tv/media/dvb/video-fopen.rst   |  112 +
 Documentation/linux_tv/media/dvb/video-freeze.rst  |   61 +
 Documentation/linux_tv/media/dvb/video-fwrite.rst  |   82 +
 .../linux_tv/media/dvb/video-get-capabilities.rst  |   61 +
 .../linux_tv/media/dvb/video-get-event.rst         |   88 +
 .../linux_tv/media/dvb/video-get-frame-count.rst   |   65 +
 .../linux_tv/media/dvb/video-get-frame-rate.rst    |   59 +
 .../linux_tv/media/dvb/video-get-navi.rst          |   74 +
 Documentation/linux_tv/media/dvb/video-get-pts.rst |   69 +
 .../linux_tv/media/dvb/video-get-size.rst          |   59 +
 .../linux_tv/media/dvb/video-get-status.rst        |   60 +
 Documentation/linux_tv/media/dvb/video-play.rst    |   57 +
 .../linux_tv/media/dvb/video-select-source.rst     |   65 +
 .../linux_tv/media/dvb/video-set-attributes.rst    |   75 +
 .../linux_tv/media/dvb/video-set-blank.rst         |   64 +
 .../media/dvb/video-set-display-format.rst         |   60 +
 .../linux_tv/media/dvb/video-set-format.rst        |   74 +
 .../linux_tv/media/dvb/video-set-highlight.rst     |   60 +
 Documentation/linux_tv/media/dvb/video-set-id.rst  |   73 +
 .../linux_tv/media/dvb/video-set-spu-palette.rst   |   72 +
 Documentation/linux_tv/media/dvb/video-set-spu.rst |   74 +
 .../linux_tv/media/dvb/video-set-streamtype.rst    |   61 +
 .../linux_tv/media/dvb/video-set-system.rst        |   75 +
 .../linux_tv/media/dvb/video-slowmotion.rst        |   74 +
 .../linux_tv/media/dvb/video-stillpicture.rst      |   61 +
 Documentation/linux_tv/media/dvb/video-stop.rst    |   74 +
 .../linux_tv/media/dvb/video-try-command.rst       |   66 +
 .../linux_tv/media/dvb/video_function_calls.rst    | 2008 +----------------
 Documentation/linux_tv/media/dvb/video_h.rst       |    6 +-
 Documentation/linux_tv/media/gen-errors.rst        |    1 +
 .../media/mediactl/media-controller-model.rst      |    2 +-
 .../linux_tv/media/mediactl/media-controller.rst   |   24 +-
 .../linux_tv/media/mediactl/media-func-close.rst   |    8 +-
 .../linux_tv/media/mediactl/media-func-ioctl.rst   |   10 +-
 .../linux_tv/media/mediactl/media-func-open.rst    |    8 +-
 .../media/mediactl/media-ioc-device-info.rst       |    6 +-
 .../media/mediactl/media-ioc-enum-entities.rst     |    8 +-
 .../media/mediactl/media-ioc-enum-links.rst        |    7 +-
 .../media/mediactl/media-ioc-g-topology.rst        |   70 +-
 .../media/mediactl/media-ioc-setup-link.rst        |    6 +-
 .../linux_tv/media/rc/remote_controllers.rst       |   16 +-
 Documentation/linux_tv/media/v4l/audio.rst         |    8 +-
 Documentation/linux_tv/media/v4l/control.rst       |    6 +-
 Documentation/linux_tv/media/v4l/dev-overlay.rst   |    2 +-
 Documentation/linux_tv/media/v4l/dmabuf.rst        |    2 +-
 .../linux_tv/media/v4l/extended-controls.rst       |  114 +-
 Documentation/linux_tv/media/v4l/func-close.rst    |    6 +-
 Documentation/linux_tv/media/v4l/func-ioctl.rst    |    6 +-
 Documentation/linux_tv/media/v4l/func-mmap.rst     |    6 +-
 Documentation/linux_tv/media/v4l/func-munmap.rst   |    6 +-
 Documentation/linux_tv/media/v4l/func-open.rst     |    6 +-
 Documentation/linux_tv/media/v4l/func-poll.rst     |   11 +-
 Documentation/linux_tv/media/v4l/func-read.rst     |    6 +-
 Documentation/linux_tv/media/v4l/func-select.rst   |   11 +-
 Documentation/linux_tv/media/v4l/func-write.rst    |    6 +-
 Documentation/linux_tv/media/v4l/hist-v4l2.rst     |    4 +-
 Documentation/linux_tv/media/v4l/pixfmt-013.rst    |   26 +-
 .../linux_tv/media/v4l/pixfmt-indexed.rst          |    2 +-
 Documentation/linux_tv/media/v4l/pixfmt-nv12.rst   |    1 +
 Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst  |    2 +
 Documentation/linux_tv/media/v4l/pixfmt-nv16.rst   |    1 +
 Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst  |    1 +
 Documentation/linux_tv/media/v4l/pixfmt-nv24.rst   |    1 +
 .../linux_tv/media/v4l/pixfmt-packed-rgb.rst       |   42 +-
 .../linux_tv/media/v4l/pixfmt-packed-yuv.rst       |    8 +-
 .../linux_tv/media/v4l/pixfmt-reserved.rst         |   66 +-
 .../linux_tv/media/v4l/pixfmt-sdr-cs08.rst         |    2 +-
 .../linux_tv/media/v4l/pixfmt-sdr-cu08.rst         |    2 +-
 .../linux_tv/media/v4l/pixfmt-srggb10.rst          |    3 +
 .../linux_tv/media/v4l/pixfmt-srggb10alaw8.rst     |    3 +
 .../linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst     |    4 +
 .../linux_tv/media/v4l/pixfmt-srggb10p.rst         |    3 +
 .../linux_tv/media/v4l/pixfmt-srggb12.rst          |    4 +
 Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst |    1 +
 .../linux_tv/media/v4l/pixfmt-yuv420m.rst          |    1 +
 .../linux_tv/media/v4l/pixfmt-yuv422m.rst          |    1 +
 .../linux_tv/media/v4l/pixfmt-yuv444m.rst          |    1 +
 .../linux_tv/media/v4l/subdev-formats.rst          |  174 +-
 Documentation/linux_tv/media/v4l/v4l2.rst          |    8 +-
 Documentation/linux_tv/media/v4l/videodev.rst      |    6 +-
 .../linux_tv/media/v4l/vidioc-create-bufs.rst      |    7 +-
 .../linux_tv/media/v4l/vidioc-cropcap.rst          |    7 +-
 .../linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst  |    7 +-
 .../linux_tv/media/v4l/vidioc-dbg-g-register.rst   |    8 +-
 .../linux_tv/media/v4l/vidioc-decoder-cmd.rst      |    8 +-
 .../linux_tv/media/v4l/vidioc-dqevent.rst          |    7 +-
 .../linux_tv/media/v4l/vidioc-dv-timings-cap.rst   |   16 +-
 .../linux_tv/media/v4l/vidioc-encoder-cmd.rst      |    8 +-
 .../linux_tv/media/v4l/vidioc-enum-dv-timings.rst  |    8 +-
 .../linux_tv/media/v4l/vidioc-enum-fmt.rst         |    7 +-
 .../media/v4l/vidioc-enum-frameintervals.rst       |    7 +-
 .../linux_tv/media/v4l/vidioc-enum-framesizes.rst  |    7 +-
 .../linux_tv/media/v4l/vidioc-enum-freq-bands.rst  |    7 +-
 .../linux_tv/media/v4l/vidioc-enumaudio.rst        |    6 +-
 .../linux_tv/media/v4l/vidioc-enumaudioout.rst     |   10 +-
 .../linux_tv/media/v4l/vidioc-enuminput.rst        |    7 +-
 .../linux_tv/media/v4l/vidioc-enumoutput.rst       |    7 +-
 .../linux_tv/media/v4l/vidioc-enumstd.rst          |    7 +-
 Documentation/linux_tv/media/v4l/vidioc-expbuf.rst |    7 +-
 .../linux_tv/media/v4l/vidioc-g-audio.rst          |    8 +-
 .../linux_tv/media/v4l/vidioc-g-audioout.rst       |   10 +-
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst |    8 +-
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst |    8 +-
 .../linux_tv/media/v4l/vidioc-g-dv-timings.rst     |   35 +-
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst |   10 +-
 .../linux_tv/media/v4l/vidioc-g-enc-index.rst      |    7 +-
 .../linux_tv/media/v4l/vidioc-g-ext-ctrls.rst      |    9 +-
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst |    8 +-
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst  |    9 +-
 .../linux_tv/media/v4l/vidioc-g-frequency.rst      |    8 +-
 .../linux_tv/media/v4l/vidioc-g-input.rst          |    7 +-
 .../linux_tv/media/v4l/vidioc-g-jpegcomp.rst       |    8 +-
 .../linux_tv/media/v4l/vidioc-g-modulator.rst      |    8 +-
 .../linux_tv/media/v4l/vidioc-g-output.rst         |    7 +-
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst |    8 +-
 .../linux_tv/media/v4l/vidioc-g-priority.rst       |   12 +-
 .../linux_tv/media/v4l/vidioc-g-selection.rst      |    8 +-
 .../linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst |    7 +-
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst  |    7 +-
 .../linux_tv/media/v4l/vidioc-g-tuner.rst          |    8 +-
 .../linux_tv/media/v4l/vidioc-log-status.rst       |   11 +-
 .../linux_tv/media/v4l/vidioc-overlay.rst          |    6 +-
 .../linux_tv/media/v4l/vidioc-prepare-buf.rst      |    6 +-
 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst   |    7 +-
 .../linux_tv/media/v4l/vidioc-query-dv-timings.rst |    7 +-
 .../linux_tv/media/v4l/vidioc-querybuf.rst         |    6 +-
 .../linux_tv/media/v4l/vidioc-querycap.rst         |    7 +-
 .../linux_tv/media/v4l/vidioc-queryctrl.rst        |    9 +-
 .../linux_tv/media/v4l/vidioc-querystd.rst         |    6 +-
 .../linux_tv/media/v4l/vidioc-reqbufs.rst          |    7 +-
 .../linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst   |    7 +-
 .../linux_tv/media/v4l/vidioc-streamon.rst         |    7 +-
 .../v4l/vidioc-subdev-enum-frame-interval.rst      |    7 +-
 .../media/v4l/vidioc-subdev-enum-frame-size.rst    |    7 +-
 .../media/v4l/vidioc-subdev-enum-mbus-code.rst     |    7 +-
 .../linux_tv/media/v4l/vidioc-subdev-g-crop.rst    |    8 +-
 .../linux_tv/media/v4l/vidioc-subdev-g-fmt.rst     |    9 +-
 .../media/v4l/vidioc-subdev-g-frame-interval.rst   |    8 +-
 .../media/v4l/vidioc-subdev-g-selection.rst        |    8 +-
 .../linux_tv/media/v4l/vidioc-subscribe-event.rst  |    8 +-
 Documentation/linux_tv/net.h.rst                   |   59 -
 Documentation/linux_tv/net.h.rst.exceptions        |   11 +
 Documentation/linux_tv/video.h.rst                 |  280 ---
 Documentation/linux_tv/video.h.rst.exceptions      |   40 +
 Documentation/linux_tv/videodev2.h.rst             | 2300 --------------------
 Documentation/linux_tv/videodev2.h.rst.exceptions  |  559 +++++
 Documentation/sphinx-static/theme_overrides.css    |   53 +
 Documentation/sphinx/kernel_include.py             |  183 ++
 Documentation/sphinx/parse-headers.pl              |  319 +++
 257 files changed, 8271 insertions(+), 10005 deletions(-)
 create mode 100644 Documentation/linux_tv/Makefile
 delete mode 100644 Documentation/linux_tv/audio.h.rst
 create mode 100644 Documentation/linux_tv/audio.h.rst.exceptions
 delete mode 100644 Documentation/linux_tv/ca.h.rst
 create mode 100644 Documentation/linux_tv/ca.h.rst.exceptions
 delete mode 100644 Documentation/linux_tv/conf.py
 delete mode 100644 Documentation/linux_tv/dmx.h.rst
 create mode 100644 Documentation/linux_tv/dmx.h.rst.exceptions
 delete mode 100644 Documentation/linux_tv/frontend.h.rst
 create mode 100644 Documentation/linux_tv/frontend.h.rst.exceptions
 create mode 100644 Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-channel-select.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-continue.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-fclose.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-fopen.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-fwrite.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-get-pts.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-get-status.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-pause.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-play.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-select-source.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-attributes.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-id.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-mixer.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-mute.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-stop.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-fclose.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-fopen.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-get-cap.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-get-descr-info.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-get-msg.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-get-slot-info.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-reset.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-send-msg.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-set-descr.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-set-pid.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-add-pid.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-fclose.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-fopen.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-fread.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-fwrite.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-get-caps.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-get-event.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-get-stc.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-set-filter.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-set-source.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-start.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-stop.rst
 rename Documentation/linux_tv/media/dvb/{FE_DISHNETWORK_SEND_LEGACY_CMD.rst => fe-dishnetwork-send-legacy-cmd.rst} (82%)
 rename Documentation/linux_tv/media/dvb/{FE_GET_EVENT.rst => fe-get-event.rst} (89%)
 rename Documentation/linux_tv/media/dvb/{FE_GET_FRONTEND.rst => fe-get-frontend.rst} (85%)
 rename Documentation/linux_tv/media/dvb/{FE_READ_BER.rst => fe-read-ber.rst} (84%)
 rename Documentation/linux_tv/media/dvb/{FE_READ_SIGNAL_STRENGTH.rst => fe-read-signal-strength.rst} (83%)
 rename Documentation/linux_tv/media/dvb/{FE_READ_SNR.rst => fe-read-snr.rst} (85%)
 rename Documentation/linux_tv/media/dvb/{FE_READ_UNCORRECTED_BLOCKS.rst => fe-read-uncorrected-blocks.rst} (85%)
 rename Documentation/linux_tv/media/dvb/{FE_SET_FRONTEND.rst => fe-set-frontend.rst} (89%)
 create mode 100644 Documentation/linux_tv/media/dvb/net-add-if.rst
 create mode 100644 Documentation/linux_tv/media/dvb/net-get-if.rst
 create mode 100644 Documentation/linux_tv/media/dvb/net-remove-if.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-clear-buffer.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-command.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-continue.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-fast-forward.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-fclose.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-fopen.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-freeze.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-fwrite.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-capabilities.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-event.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-frame-count.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-navi.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-pts.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-size.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-status.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-play.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-select-source.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-attributes.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-blank.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-display-format.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-format.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-highlight.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-id.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-spu.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-streamtype.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-system.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-slowmotion.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-stillpicture.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-stop.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-try-command.rst
 delete mode 100644 Documentation/linux_tv/net.h.rst
 create mode 100644 Documentation/linux_tv/net.h.rst.exceptions
 delete mode 100644 Documentation/linux_tv/video.h.rst
 create mode 100644 Documentation/linux_tv/video.h.rst.exceptions
 delete mode 100644 Documentation/linux_tv/videodev2.h.rst
 create mode 100644 Documentation/linux_tv/videodev2.h.rst.exceptions
 create mode 100644 Documentation/sphinx-static/theme_overrides.css
 create mode 100755 Documentation/sphinx/kernel_include.py
 create mode 100755 Documentation/sphinx/parse-headers.pl

-- 
2.7.4

