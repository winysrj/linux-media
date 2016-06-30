Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:57863 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200AbcF3O7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 10:59:03 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [GIT PULL] doc: linux_tv DocBook to reST migration (docs-next)
Date: Thu, 30 Jun 2016 16:52:21 +0200
Message-Id: <2D28134C-69FB-4662-ABDA-0590E42A4AB9@darmarit.de>
Cc: LMML linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

this is the reST migration of the *media* DocBook-XML set [1]. Its
based on your:

  https://git.linuxtv.org/mchehab/experimental.git mchehab/docs-next

Since the flat-table patch is not yet in Jon's docs-next and your
mchehab/docs-next is one behind Jon', I had to merge these patches.

[1] http://mid.gmane.org/20160630071813.05a94cb1@recife.lan

-- Markus --

PS: one week earlier than annonced [1] ... call "Mr. Wolf" ;-)


----------------------------------------------------------------

The following changes since commit 4b194975b3173a8c96661aa3c2f2a101021a10fa:

  Merge pedra:/devel/v4l/patchwork into devel/docs-next (2016-06-24 07:31:30 -0300)

are available in the git repository at:

  https://github.com/return42/linux.git linux_tv_migration

for you to fetch changes up to d949b369ea505b6a0f43abe4ec32ce35a9adacd0:

  doc-rst: linux_tv DocBook to reST migration (docs-next) (2016-06-30 15:18:56 +0200)

----------------------------------------------------------------
Jani Nikula (1):
      Documentation: add meta-documentation for Sphinx and kernel-doc

Markus Heiser (3):
      doc-rst: flat-table directive - initial implementation
      Merge branch 'docs-next/flat-table' into linux_tv_migration
      doc-rst: linux_tv DocBook to reST migration (docs-next)

 Documentation/conf.py                                                               |     2 +-
 Documentation/index.rst                                                             |     2 +
 Documentation/kernel-documentation.rst                                              |   647 +++
 Documentation/linux_tv/audio.h.rst                                                  |   153 +
 Documentation/linux_tv/ca.h.rst                                                     |   108 +
 Documentation/linux_tv/conf.py                                                      |   221 +
 Documentation/linux_tv/dmx.h.rst                                                    |   173 +
 Documentation/linux_tv/frontend.h.rst                                               |   620 ++
 Documentation/linux_tv/index.rst                                                    |   100 +
 Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst                 |    55 +
 Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst                                   |    89 +
 Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst                                |    77 +
 Documentation/linux_tv/media/dvb/FE_READ_BER.rst                                    |    61 +
 Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst                        |    64 +
 Documentation/linux_tv/media/dvb/FE_READ_SNR.rst                                    |    61 +
 Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst                     |    66 +
 Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst                                |    84 +
 Documentation/linux_tv/media/dvb/audio.rst                                          |    37 +
 Documentation/linux_tv/media/dvb/audio_data_types.rst                               |   187 +
 Documentation/linux_tv/media/dvb/audio_function_calls.rst                           |  1308 +++++
 Documentation/linux_tv/media/dvb/audio_h.rst                                        |    24 +
 Documentation/linux_tv/media/dvb/ca.rst                                             |    29 +
 Documentation/linux_tv/media/dvb/ca_data_types.rst                                  |   121 +
 Documentation/linux_tv/media/dvb/ca_function_calls.rst                              |   541 ++
 Documentation/linux_tv/media/dvb/ca_h.rst                                           |    24 +
 Documentation/linux_tv/media/dvb/demux.rst                                          |    29 +
 Documentation/linux_tv/media/dvb/dmx_fcalls.rst                                     |  1013 ++++
 Documentation/linux_tv/media/dvb/dmx_h.rst                                          |    24 +
 Documentation/linux_tv/media/dvb/dmx_types.rst                                      |   253 +
 Documentation/linux_tv/media/dvb/dtv-fe-stats.rst                                   |    28 +
 Documentation/linux_tv/media/dvb/dtv-properties.rst                                 |    26 +
 Documentation/linux_tv/media/dvb/dtv-property.rst                                   |    42 +
 Documentation/linux_tv/media/dvb/dtv-stats.rst                                      |    29 +
 Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst                             |    31 +
 Documentation/linux_tv/media/dvb/dvb-frontend-event.rst                             |    26 +
 Documentation/linux_tv/media/dvb/dvb-frontend-parameters.rst                        |   130 +
 Documentation/linux_tv/media/dvb/dvbapi.rst                                         |    95 +
 Documentation/linux_tv/media/dvb/dvbproperty-006.rst                                |    21 +
 Documentation/linux_tv/media/dvb/dvbproperty.rst                                    |   122 +
 Documentation/linux_tv/media/dvb/examples.rst                                       |   391 ++
 Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst                                 |    88 +
 Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst                     |    88 +
 Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst                       |    51 +
 Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst                           |    93 +
 Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst                      |    78 +
 Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst                     |    58 +
 Documentation/linux_tv/media/dvb/fe-get-info.rst                                    |   434 ++
 Documentation/linux_tv/media/dvb/fe-get-property.rst                                |    75 +
 Documentation/linux_tv/media/dvb/fe-read-status.rst                                 |   143 +
 Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst                      |    60 +
 Documentation/linux_tv/media/dvb/fe-set-tone.rst                                    |   100 +
 Documentation/linux_tv/media/dvb/fe-set-voltage.rst                                 |    68 +
 Documentation/linux_tv/media/dvb/fe-type-t.rst                                      |   100 +
 Documentation/linux_tv/media/dvb/fe_property_parameters.rst                         |  1976 +++++++
 Documentation/linux_tv/media/dvb/frontend-property-cable-systems.rst                |    84 +
 Documentation/linux_tv/media/dvb/frontend-property-satellite-systems.rst            |   112 +
 Documentation/linux_tv/media/dvb/frontend-property-terrestrial-systems.rst          |   303 +
 Documentation/linux_tv/media/dvb/frontend-stat-properties.rst                       |   254 +
 Documentation/linux_tv/media/dvb/frontend.rst                                       |    62 +
 Documentation/linux_tv/media/dvb/frontend_f_close.rst                               |    55 +
 Documentation/linux_tv/media/dvb/frontend_f_open.rst                                |   108 +
 Documentation/linux_tv/media/dvb/frontend_fcalls.rst                                |    35 +
 Documentation/linux_tv/media/dvb/frontend_h.rst                                     |    24 +
 Documentation/linux_tv/media/dvb/frontend_legacy_api.rst                            |    49 +
 Documentation/linux_tv/media/dvb/frontend_legacy_dvbv3_api.rst                      |    29 +
 Documentation/linux_tv/media/dvb/intro.rst                                          |   204 +
 Documentation/linux_tv/media/dvb/intro_files/dvbstb.pdf                             |   Bin 0 -> 1881 bytes
 Documentation/linux_tv/media/dvb/intro_files/dvbstb.png                             |   Bin 0 -> 22655 bytes
 Documentation/linux_tv/media/dvb/legacy_dvb_apis.rst                                |    31 +
 Documentation/linux_tv/media/dvb/net.rst                                            |   219 +
 Documentation/linux_tv/media/dvb/net_h.rst                                          |    24 +
 Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst                        |    22 +
 Documentation/linux_tv/media/dvb/video.rst                                          |    46 +
 Documentation/linux_tv/media/dvb/video_function_calls.rst                           |  1880 ++++++
 Documentation/linux_tv/media/dvb/video_h.rst                                        |    24 +
 Documentation/linux_tv/media/dvb/video_types.rst                                    |   390 ++
 Documentation/linux_tv/media/v4l/Remote_controllers_Intro.rst                       |    33 +
 Documentation/linux_tv/media/v4l/Remote_controllers_table_change.rst                |    29 +
 Documentation/linux_tv/media/v4l/Remote_controllers_tables.rst                      |   768 +++
 Documentation/linux_tv/media/v4l/app-pri.rst                                        |    39 +
 Documentation/linux_tv/media/v4l/async.rst                                          |    18 +
 Documentation/linux_tv/media/v4l/audio.rst                                          |    97 +
 Documentation/linux_tv/media/v4l/biblio.rst                                         |   390 ++
 Documentation/linux_tv/media/v4l/buffer.rst                                         |   966 ++++
 Documentation/linux_tv/media/v4l/capture-example.rst                                |    24 +
 Documentation/linux_tv/media/v4l/capture.c.rst                                      |   675 +++
 Documentation/linux_tv/media/v4l/colorspaces.rst                                    |   172 +
 Documentation/linux_tv/media/v4l/common-defs.rst                                    |    24 +
 Documentation/linux_tv/media/v4l/common.rst                                         |    56 +
 Documentation/linux_tv/media/v4l/compat.rst                                         |    29 +
 Documentation/linux_tv/media/v4l/control.rst                                        |   536 ++
 Documentation/linux_tv/media/v4l/controls.rst                                       |    18 +
 Documentation/linux_tv/media/v4l/crop.rst                                           |   300 +
 Documentation/linux_tv/media/v4l/crop_files/crop.gif                                |   Bin 0 -> 5967 bytes
 Documentation/linux_tv/media/v4l/crop_files/crop.pdf                                |   Bin 0 -> 5846 bytes
 Documentation/linux_tv/media/v4l/depth-formats.rst                                  |    26 +
 Documentation/linux_tv/media/v4l/dev-capture.rst                                    |   111 +
 Documentation/linux_tv/media/v4l/dev-codec.rst                                      |    41 +
 Documentation/linux_tv/media/v4l/dev-effect.rst                                     |    31 +
 Documentation/linux_tv/media/v4l/dev-event.rst                                      |    56 +
 Documentation/linux_tv/media/v4l/dev-osd.rst                                        |   154 +
 Documentation/linux_tv/media/v4l/dev-output.rst                                     |   108 +
 Documentation/linux_tv/media/v4l/dev-overlay.rst                                    |   328 ++
 Documentation/linux_tv/media/v4l/dev-radio.rst                                      |    61 +
 Documentation/linux_tv/media/v4l/dev-raw-vbi.rst                                    |   368 ++
 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_525.gif                      |   Bin 0 -> 4741 bytes
 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_525.pdf                      |   Bin 0 -> 3395 bytes
 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_625.gif                      |   Bin 0 -> 5095 bytes
 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_625.pdf                      |   Bin 0 -> 3683 bytes
 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_hsync.gif                    |   Bin 0 -> 2400 bytes
 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_hsync.pdf                    |   Bin 0 -> 7405 bytes
 Documentation/linux_tv/media/v4l/dev-rds.rst                                        |   266 +
 Documentation/linux_tv/media/v4l/dev-sdr.rst                                        |   129 +
 Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst                                 |   804 +++
 Documentation/linux_tv/media/v4l/dev-subdev.rst                                     |   502 ++
 Documentation/linux_tv/media/v4l/dev-subdev_files/pipeline.pdf                      |   Bin 0 -> 20276 bytes
 Documentation/linux_tv/media/v4l/dev-subdev_files/pipeline.png                      |   Bin 0 -> 12130 bytes
 Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-crop.pdf  |   Bin 0 -> 20729 bytes
 Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-crop.svg  |    63 +
 Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-full.pdf  |   Bin 0 -> 46311 bytes
 Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-full.svg  |   163 +
 .../media/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.pdf     |   Bin 0 -> 36714 bytes
 .../media/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg     |   116 +
 Documentation/linux_tv/media/v4l/dev-teletext.rst                                   |    43 +
 Documentation/linux_tv/media/v4l/devices.rst                                        |    37 +
 Documentation/linux_tv/media/v4l/diff-v4l.rst                                       |   963 ++++
 Documentation/linux_tv/media/v4l/dmabuf.rst                                         |   158 +
 Documentation/linux_tv/media/v4l/driver.rst                                         |    18 +
 Documentation/linux_tv/media/v4l/dv-timings.rst                                     |    47 +
 Documentation/linux_tv/media/v4l/extended-controls.rst                              |  4533 +++++++++++++++
 Documentation/linux_tv/media/v4l/fdl-appendix.rst                                   |   487 ++
 Documentation/linux_tv/media/v4l/field-order.rst                                    |   210 +
 Documentation/linux_tv/media/v4l/field-order_files/fieldseq_bt.gif                  |   Bin 0 -> 25430 bytes
 Documentation/linux_tv/media/v4l/field-order_files/fieldseq_bt.pdf                  |   Bin 0 -> 9185 bytes
 Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.gif                  |   Bin 0 -> 25323 bytes
 Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.pdf                  |   Bin 0 -> 9173 bytes
 Documentation/linux_tv/media/v4l/format.rst                                         |   101 +
 Documentation/linux_tv/media/v4l/func-close.rst                                     |    56 +
 Documentation/linux_tv/media/v4l/func-ioctl.rst                                     |    69 +
 Documentation/linux_tv/media/v4l/func-mmap.rst                                      |   141 +
 Documentation/linux_tv/media/v4l/func-munmap.rst                                    |    65 +
 Documentation/linux_tv/media/v4l/func-open.rst                                      |    90 +
 Documentation/linux_tv/media/v4l/func-poll.rst                                      |   118 +
 Documentation/linux_tv/media/v4l/func-read.rst                                      |   138 +
 Documentation/linux_tv/media/v4l/func-select.rst                                    |   108 +
 Documentation/linux_tv/media/v4l/func-write.rst                                     |    89 +
 Documentation/linux_tv/media/v4l/gen-errors.rst                                     |   109 +
 Documentation/linux_tv/media/v4l/hist-v4l2.rst                                      |  1490 +++++
 Documentation/linux_tv/media/v4l/io.rst                                             |    62 +
 Documentation/linux_tv/media/v4l/keytable.c.rst                                     |   187 +
 Documentation/linux_tv/media/v4l/libv4l-introduction.rst                            |   178 +
 Documentation/linux_tv/media/v4l/libv4l.rst                                         |    24 +
 Documentation/linux_tv/media/v4l/lirc_dev_intro.rst                                 |    37 +
 Documentation/linux_tv/media/v4l/lirc_device_interface.rst                          |    26 +
 Documentation/linux_tv/media/v4l/lirc_ioctl.rst                                     |   165 +
 Documentation/linux_tv/media/v4l/lirc_read.rst                                      |    28 +
 Documentation/linux_tv/media/v4l/lirc_write.rst                                     |    23 +
 Documentation/linux_tv/media/v4l/media-controller-intro.rst                         |    42 +
 Documentation/linux_tv/media/v4l/media-controller-model.rst                         |    44 +
 Documentation/linux_tv/media/v4l/media-controller.rst                               |    66 +
 Documentation/linux_tv/media/v4l/media-func-close.rst                               |    54 +
 Documentation/linux_tv/media/v4l/media-func-ioctl.rst                               |    74 +
 Documentation/linux_tv/media/v4l/media-func-open.rst                                |    76 +
 Documentation/linux_tv/media/v4l/media-ioc-device-info.rst                          |   149 +
 Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst                        |   204 +
 Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst                           |   180 +
 Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst                           |   436 ++
 Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst                           |    75 +
 Documentation/linux_tv/media/v4l/media-types.rst                                    |   433 ++
 Documentation/linux_tv/media/v4l/mmap.rst                                           |   286 +
 Documentation/linux_tv/media/v4l/open.rst                                           |   168 +
 Documentation/linux_tv/media/v4l/pixfmt-002.rst                                     |   207 +
 Documentation/linux_tv/media/v4l/pixfmt-003.rst                                     |   177 +
 Documentation/linux_tv/media/v4l/pixfmt-004.rst                                     |    60 +
 Documentation/linux_tv/media/v4l/pixfmt-006.rst                                     |   291 +
 Documentation/linux_tv/media/v4l/pixfmt-007.rst                                     |   870 +++
 Documentation/linux_tv/media/v4l/pixfmt-008.rst                                     |    41 +
 Documentation/linux_tv/media/v4l/pixfmt-013.rst                                     |   140 +
 Documentation/linux_tv/media/v4l/pixfmt-grey.rst                                    |    89 +
 Documentation/linux_tv/media/v4l/pixfmt-indexed.rst                                 |    84 +
 Documentation/linux_tv/media/v4l/pixfmt-m420.rst                                    |   238 +
 Documentation/linux_tv/media/v4l/pixfmt-nv12.rst                                    |   241 +
 Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst                                   |   256 +
 Documentation/linux_tv/media/v4l/pixfmt-nv12mt.rst                                  |    71 +
 Documentation/linux_tv/media/v4l/pixfmt-nv12mt_files/nv12mt.gif                     |   Bin 0 -> 2108 bytes
 Documentation/linux_tv/media/v4l/pixfmt-nv12mt_files/nv12mt_example.gif             |   Bin 0 -> 6858 bytes
 Documentation/linux_tv/media/v4l/pixfmt-nv16.rst                                    |   290 +
 Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst                                   |   297 +
 Documentation/linux_tv/media/v4l/pixfmt-nv24.rst                                    |   182 +
 Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst                              |  1479 +++++
 Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst                              |   325 ++
 Documentation/linux_tv/media/v4l/pixfmt-reserved.rst                                |   371 ++
 Documentation/linux_tv/media/v4l/pixfmt-rgb.rst                                     |    34 +
 Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst                                 |   125 +
 Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst                                  |    93 +
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst                                |    55 +
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst                              |    60 +
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst                                |    55 +
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst                              |    59 +
 Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst                              |    50 +
 Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst                                  |    93 +
 Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst                                  |    93 +
 Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst                                 |   129 +
 Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst                            |    32 +
 Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst                            |    33 +
 Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst                                |   112 +
 Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst                                 |   129 +
 Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst                                  |    93 +
 Documentation/linux_tv/media/v4l/pixfmt-uv8.rst                                     |    88 +
 Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst                                    |   216 +
 Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst                                    |   216 +
 Documentation/linux_tv/media/v4l/pixfmt-y10.rst                                     |   122 +
 Documentation/linux_tv/media/v4l/pixfmt-y10b.rst                                    |    56 +
 Documentation/linux_tv/media/v4l/pixfmt-y12.rst                                     |   122 +
 Documentation/linux_tv/media/v4l/pixfmt-y12i.rst                                    |    59 +
 Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst                                  |   123 +
 Documentation/linux_tv/media/v4l/pixfmt-y16.rst                                     |   123 +
 Documentation/linux_tv/media/v4l/pixfmt-y41p.rst                                    |   313 +
 Documentation/linux_tv/media/v4l/pixfmt-y8i.rst                                     |   123 +
 Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst                                  |   219 +
 Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst                                 |   237 +
 Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst                                  |   250 +
 Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst                                 |   265 +
 Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst                                 |   274 +
 Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst                                 |   257 +
 Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst                                 |   294 +
 Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst                                    |   217 +
 Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst                                    |   216 +
 Documentation/linux_tv/media/v4l/pixfmt-z16.rst                                     |   123 +
 Documentation/linux_tv/media/v4l/pixfmt.rst                                         |    46 +
 Documentation/linux_tv/media/v4l/planar-apis.rst                                    |    74 +
 Documentation/linux_tv/media/v4l/querycap.rst                                       |    43 +
 Documentation/linux_tv/media/v4l/remote_controllers.rst                             |    53 +
 Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst                 |   152 +
 Documentation/linux_tv/media/v4l/rw.rst                                             |    56 +
 Documentation/linux_tv/media/v4l/sdr-formats.rst                                    |    30 +
 Documentation/linux_tv/media/v4l/selection-api-002.rst                              |    37 +
 Documentation/linux_tv/media/v4l/selection-api-003.rst                              |    29 +
 Documentation/linux_tv/media/v4l/selection-api-003_files/selection.png              |   Bin 0 -> 11716 bytes
 Documentation/linux_tv/media/v4l/selection-api-004.rst                              |   146 +
 Documentation/linux_tv/media/v4l/selection-api-005.rst                              |    42 +
 Documentation/linux_tv/media/v4l/selection-api-006.rst                              |    89 +
 Documentation/linux_tv/media/v4l/selection-api.rst                                  |    27 +
 Documentation/linux_tv/media/v4l/selections-common.rst                              |    34 +
 Documentation/linux_tv/media/v4l/standard.rst                                       |   185 +
 Documentation/linux_tv/media/v4l/streaming-par.rst                                  |    42 +
 Documentation/linux_tv/media/v4l/subdev-formats.rst                                 | 11701 ++++++++++++++++++++++++++++++++++++++
 Documentation/linux_tv/media/v4l/subdev-formats_files/bayer.png                     |   Bin 0 -> 9725 bytes
 Documentation/linux_tv/media/v4l/tuner.rst                                          |    91 +
 Documentation/linux_tv/media/v4l/user-func.rst                                      |    92 +
 Documentation/linux_tv/media/v4l/userp.rst                                          |   123 +
 Documentation/linux_tv/media/v4l/v4l2-selection-flags.rst                           |    82 +
 Documentation/linux_tv/media/v4l/v4l2-selection-targets.rst                         |   146 +
 Documentation/linux_tv/media/v4l/v4l2.rst                                           |   392 ++
 Documentation/linux_tv/media/v4l/v4l2grab-example.rst                               |    28 +
 Documentation/linux_tv/media/v4l/v4l2grab.c.rst                                     |   180 +
 Documentation/linux_tv/media/v4l/video.rst                                          |    73 +
 Documentation/linux_tv/media/v4l/videodev.rst                                       |    24 +
 Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst                             |   154 +
 Documentation/linux_tv/media/v4l/vidioc-cropcap.rst                                 |   175 +
 Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst                         |   212 +
 Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst                          |   218 +
 Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst                             |   280 +
 Documentation/linux_tv/media/v4l/vidioc-dqevent.rst                                 |   581 ++
 Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst                          |   259 +
 Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst                             |   204 +
 Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst                         |   128 +
 Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst                                |   172 +
 Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst                     |   282 +
 Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst                         |   299 +
 Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst                         |   198 +
 Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst                               |    63 +
 Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst                            |    66 +
 Documentation/linux_tv/media/v4l/vidioc-enuminput.rst                               |   375 ++
 Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst                              |   230 +
 Documentation/linux_tv/media/v4l/vidioc-enumstd.rst                                 |   450 ++
 Documentation/linux_tv/media/v4l/vidioc-expbuf.rst                                  |   205 +
 Documentation/linux_tv/media/v4l/vidioc-g-audio.rst                                 |   171 +
 Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst                              |   131 +
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst                                  |   122 +
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst                                  |   114 +
 Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst                            |   429 ++
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst                                  |   171 +
 Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst                             |   218 +
 Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst                             |   498 ++
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst                                  |   509 ++
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst                                   |   198 +
 Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst                             |   132 +
 Documentation/linux_tv/media/v4l/vidioc-g-input.rst                                 |    70 +
 Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst                              |   191 +
 Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst                             |   264 +
 Documentation/linux_tv/media/v4l/vidioc-g-output.rst                                |    72 +
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst                                  |   358 ++
 Documentation/linux_tv/media/v4l/vidioc-g-priority.rst                              |   126 +
 Documentation/linux_tv/media/v4l/vidioc-g-selection.rst                             |   218 +
 Documentation/linux_tv/media/v4l/vidioc-g-selection_files/constraints.png           |   Bin 0 -> 3313 bytes
 Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst                        |   284 +
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst                                   |    76 +
 Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst                                 |   724 +++
 Documentation/linux_tv/media/v4l/vidioc-log-status.rst                              |    48 +
 Documentation/linux_tv/media/v4l/vidioc-overlay.rst                                 |    62 +
 Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst                             |    69 +
 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst                                    |   158 +
 Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst                        |    91 +
 Documentation/linux_tv/media/v4l/vidioc-querybuf.rst                                |    88 +
 Documentation/linux_tv/media/v4l/vidioc-querycap.rst                                |   442 ++
 Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst                               |   790 +++
 Documentation/linux_tv/media/v4l/vidioc-querystd.rst                                |    73 +
 Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst                                 |   133 +
 Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst                          |   187 +
 Documentation/linux_tv/media/v4l/vidioc-streamon.rst                                |   111 +
 Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst              |   161 +
 Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst                  |   170 +
 Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst                   |   123 +
 Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst                           |   145 +
 Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst                            |   181 +
 Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst                 |   131 +
 Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst                      |   153 +
 Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst                         |   144 +
 Documentation/linux_tv/media/v4l/yuv-formats.rst                                    |    66 +
 Documentation/linux_tv/media_api_files/typical_media_device.pdf                     |   Bin 0 -> 134268 bytes
 Documentation/linux_tv/media_api_files/typical_media_device.svg                     |    28 +
 Documentation/linux_tv/net.h.rst                                                    |    70 +
 Documentation/linux_tv/video.h.rst                                                  |   291 +
 Documentation/linux_tv/videodev2.h.rst                                              |  2311 ++++++++
 Documentation/sphinx/rstFlatTable.py                                                |   365 ++
 326 files changed, 75170 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/kernel-documentation.rst
 create mode 100644 Documentation/linux_tv/audio.h.rst
 create mode 100644 Documentation/linux_tv/ca.h.rst
 create mode 100644 Documentation/linux_tv/conf.py
 create mode 100644 Documentation/linux_tv/dmx.h.rst
 create mode 100644 Documentation/linux_tv/frontend.h.rst
 create mode 100644 Documentation/linux_tv/index.rst
 create mode 100644 Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
 create mode 100644 Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
 create mode 100644 Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
 create mode 100644 Documentation/linux_tv/media/dvb/FE_READ_BER.rst
 create mode 100644 Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
 create mode 100644 Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
 create mode 100644 Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
 create mode 100644 Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio_data_types.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio_function_calls.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio_h.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca_data_types.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca_function_calls.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca_h.rst
 create mode 100644 Documentation/linux_tv/media/dvb/demux.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx_fcalls.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx_h.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx_types.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dtv-fe-stats.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dtv-properties.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dtv-property.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dtv-stats.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dvb-frontend-event.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dvb-frontend-parameters.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dvbapi.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dvbproperty-006.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dvbproperty.rst
 create mode 100644 Documentation/linux_tv/media/dvb/examples.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-bandwidth-t.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-get-info.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-get-property.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-read-status.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-set-tone.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-set-voltage.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe-type-t.rst
 create mode 100644 Documentation/linux_tv/media/dvb/fe_property_parameters.rst
 create mode 100644 Documentation/linux_tv/media/dvb/frontend-property-cable-systems.rst
 create mode 100644 Documentation/linux_tv/media/dvb/frontend-property-satellite-systems.rst
 create mode 100644 Documentation/linux_tv/media/dvb/frontend-property-terrestrial-systems.rst
 create mode 100644 Documentation/linux_tv/media/dvb/frontend-stat-properties.rst
 create mode 100644 Documentation/linux_tv/media/dvb/frontend.rst
 create mode 100644 Documentation/linux_tv/media/dvb/frontend_f_close.rst
 create mode 100644 Documentation/linux_tv/media/dvb/frontend_f_open.rst
 create mode 100644 Documentation/linux_tv/media/dvb/frontend_fcalls.rst
 create mode 100644 Documentation/linux_tv/media/dvb/frontend_h.rst
 create mode 100644 Documentation/linux_tv/media/dvb/frontend_legacy_api.rst
 create mode 100644 Documentation/linux_tv/media/dvb/frontend_legacy_dvbv3_api.rst
 create mode 100644 Documentation/linux_tv/media/dvb/intro.rst
 create mode 100644 Documentation/linux_tv/media/dvb/intro_files/dvbstb.pdf
 create mode 100644 Documentation/linux_tv/media/dvb/intro_files/dvbstb.png
 create mode 100644 Documentation/linux_tv/media/dvb/legacy_dvb_apis.rst
 create mode 100644 Documentation/linux_tv/media/dvb/net.rst
 create mode 100644 Documentation/linux_tv/media/dvb/net_h.rst
 create mode 100644 Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video_function_calls.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video_h.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video_types.rst
 create mode 100644 Documentation/linux_tv/media/v4l/Remote_controllers_Intro.rst
 create mode 100644 Documentation/linux_tv/media/v4l/Remote_controllers_table_change.rst
 create mode 100644 Documentation/linux_tv/media/v4l/Remote_controllers_tables.rst
 create mode 100644 Documentation/linux_tv/media/v4l/app-pri.rst
 create mode 100644 Documentation/linux_tv/media/v4l/async.rst
 create mode 100644 Documentation/linux_tv/media/v4l/audio.rst
 create mode 100644 Documentation/linux_tv/media/v4l/biblio.rst
 create mode 100644 Documentation/linux_tv/media/v4l/buffer.rst
 create mode 100644 Documentation/linux_tv/media/v4l/capture-example.rst
 create mode 100644 Documentation/linux_tv/media/v4l/capture.c.rst
 create mode 100644 Documentation/linux_tv/media/v4l/colorspaces.rst
 create mode 100644 Documentation/linux_tv/media/v4l/common-defs.rst
 create mode 100644 Documentation/linux_tv/media/v4l/common.rst
 create mode 100644 Documentation/linux_tv/media/v4l/compat.rst
 create mode 100644 Documentation/linux_tv/media/v4l/control.rst
 create mode 100644 Documentation/linux_tv/media/v4l/controls.rst
 create mode 100644 Documentation/linux_tv/media/v4l/crop.rst
 create mode 100644 Documentation/linux_tv/media/v4l/crop_files/crop.gif
 create mode 100644 Documentation/linux_tv/media/v4l/crop_files/crop.pdf
 create mode 100644 Documentation/linux_tv/media/v4l/depth-formats.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-capture.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-codec.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-effect.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-event.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-osd.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-output.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-overlay.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-radio.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_525.gif
 create mode 100644 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_525.pdf
 create mode 100644 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_625.gif
 create mode 100644 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_625.pdf
 create mode 100644 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_hsync.gif
 create mode 100644 Documentation/linux_tv/media/v4l/dev-raw-vbi_files/vbi_hsync.pdf
 create mode 100644 Documentation/linux_tv/media/v4l/dev-rds.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-sdr.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-subdev.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dev-subdev_files/pipeline.pdf
 create mode 100644 Documentation/linux_tv/media/v4l/dev-subdev_files/pipeline.png
 create mode 100644 Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-crop.pdf
 create mode 100644 Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-crop.svg
 create mode 100644 Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-full.pdf
 create mode 100644 Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-full.svg
 create mode 100644 Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.pdf
 create mode 100644 Documentation/linux_tv/media/v4l/dev-subdev_files/subdev-image-processing-scaling-multi-source.svg
 create mode 100644 Documentation/linux_tv/media/v4l/dev-teletext.rst
 create mode 100644 Documentation/linux_tv/media/v4l/devices.rst
 create mode 100644 Documentation/linux_tv/media/v4l/diff-v4l.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dmabuf.rst
 create mode 100644 Documentation/linux_tv/media/v4l/driver.rst
 create mode 100644 Documentation/linux_tv/media/v4l/dv-timings.rst
 create mode 100644 Documentation/linux_tv/media/v4l/extended-controls.rst
 create mode 100644 Documentation/linux_tv/media/v4l/fdl-appendix.rst
 create mode 100644 Documentation/linux_tv/media/v4l/field-order.rst
 create mode 100644 Documentation/linux_tv/media/v4l/field-order_files/fieldseq_bt.gif
 create mode 100644 Documentation/linux_tv/media/v4l/field-order_files/fieldseq_bt.pdf
 create mode 100644 Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.gif
 create mode 100644 Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.pdf
 create mode 100644 Documentation/linux_tv/media/v4l/format.rst
 create mode 100644 Documentation/linux_tv/media/v4l/func-close.rst
 create mode 100644 Documentation/linux_tv/media/v4l/func-ioctl.rst
 create mode 100644 Documentation/linux_tv/media/v4l/func-mmap.rst
 create mode 100644 Documentation/linux_tv/media/v4l/func-munmap.rst
 create mode 100644 Documentation/linux_tv/media/v4l/func-open.rst
 create mode 100644 Documentation/linux_tv/media/v4l/func-poll.rst
 create mode 100644 Documentation/linux_tv/media/v4l/func-read.rst
 create mode 100644 Documentation/linux_tv/media/v4l/func-select.rst
 create mode 100644 Documentation/linux_tv/media/v4l/func-write.rst
 create mode 100644 Documentation/linux_tv/media/v4l/gen-errors.rst
 create mode 100644 Documentation/linux_tv/media/v4l/hist-v4l2.rst
 create mode 100644 Documentation/linux_tv/media/v4l/io.rst
 create mode 100644 Documentation/linux_tv/media/v4l/keytable.c.rst
 create mode 100644 Documentation/linux_tv/media/v4l/libv4l-introduction.rst
 create mode 100644 Documentation/linux_tv/media/v4l/libv4l.rst
 create mode 100644 Documentation/linux_tv/media/v4l/lirc_dev_intro.rst
 create mode 100644 Documentation/linux_tv/media/v4l/lirc_device_interface.rst
 create mode 100644 Documentation/linux_tv/media/v4l/lirc_ioctl.rst
 create mode 100644 Documentation/linux_tv/media/v4l/lirc_read.rst
 create mode 100644 Documentation/linux_tv/media/v4l/lirc_write.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-controller-intro.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-controller-model.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-controller.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-func-close.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-func-ioctl.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-func-open.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-ioc-device-info.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst
 create mode 100644 Documentation/linux_tv/media/v4l/media-types.rst
 create mode 100644 Documentation/linux_tv/media/v4l/mmap.rst
 create mode 100644 Documentation/linux_tv/media/v4l/open.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-002.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-003.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-004.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-006.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-007.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-008.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-013.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-grey.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-indexed.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-m420.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-nv12mt.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-nv12mt_files/nv12mt.gif
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-nv12mt_files/nv12mt_example.gif
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-nv24.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-packed-yuv.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-reserved.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-rgb.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-uv8.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-y10.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-y10b.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-y12.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-y12i.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-y16.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-y41p.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-y8i.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt-z16.rst
 create mode 100644 Documentation/linux_tv/media/v4l/pixfmt.rst
 create mode 100644 Documentation/linux_tv/media/v4l/planar-apis.rst
 create mode 100644 Documentation/linux_tv/media/v4l/querycap.rst
 create mode 100644 Documentation/linux_tv/media/v4l/remote_controllers.rst
 create mode 100644 Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst
 create mode 100644 Documentation/linux_tv/media/v4l/rw.rst
 create mode 100644 Documentation/linux_tv/media/v4l/sdr-formats.rst
 create mode 100644 Documentation/linux_tv/media/v4l/selection-api-002.rst
 create mode 100644 Documentation/linux_tv/media/v4l/selection-api-003.rst
 create mode 100644 Documentation/linux_tv/media/v4l/selection-api-003_files/selection.png
 create mode 100644 Documentation/linux_tv/media/v4l/selection-api-004.rst
 create mode 100644 Documentation/linux_tv/media/v4l/selection-api-005.rst
 create mode 100644 Documentation/linux_tv/media/v4l/selection-api-006.rst
 create mode 100644 Documentation/linux_tv/media/v4l/selection-api.rst
 create mode 100644 Documentation/linux_tv/media/v4l/selections-common.rst
 create mode 100644 Documentation/linux_tv/media/v4l/standard.rst
 create mode 100644 Documentation/linux_tv/media/v4l/streaming-par.rst
 create mode 100644 Documentation/linux_tv/media/v4l/subdev-formats.rst
 create mode 100644 Documentation/linux_tv/media/v4l/subdev-formats_files/bayer.png
 create mode 100644 Documentation/linux_tv/media/v4l/tuner.rst
 create mode 100644 Documentation/linux_tv/media/v4l/user-func.rst
 create mode 100644 Documentation/linux_tv/media/v4l/userp.rst
 create mode 100644 Documentation/linux_tv/media/v4l/v4l2-selection-flags.rst
 create mode 100644 Documentation/linux_tv/media/v4l/v4l2-selection-targets.rst
 create mode 100644 Documentation/linux_tv/media/v4l/v4l2.rst
 create mode 100644 Documentation/linux_tv/media/v4l/v4l2grab-example.rst
 create mode 100644 Documentation/linux_tv/media/v4l/v4l2grab.c.rst
 create mode 100644 Documentation/linux_tv/media/v4l/video.rst
 create mode 100644 Documentation/linux_tv/media/v4l/videodev.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-input.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-output.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-selection_files/constraints.png
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-std.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-log-status.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-overlay.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-querycap.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-querystd.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-streamon.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
 create mode 100644 Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
 create mode 100644 Documentation/linux_tv/media/v4l/yuv-formats.rst
 create mode 100644 Documentation/linux_tv/media_api_files/typical_media_device.pdf
 create mode 100644 Documentation/linux_tv/media_api_files/typical_media_device.svg
 create mode 100644 Documentation/linux_tv/net.h.rst
 create mode 100644 Documentation/linux_tv/video.h.rst
 create mode 100644 Documentation/linux_tv/videodev2.h.rst
 create mode 100644 Documentation/sphinx/rstFlatTable.py

