Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1505 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaBJJnr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 04:43:47 -0500
Message-ID: <52F89F2E.3040902@xs4all.nl>
Date: Mon, 10 Feb 2014 10:43:10 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 00/86] SDR tree
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

I have a few questions about this patch series:

First of all, would this work for a rtl2838 as well or is this really 2832u
specific? I've got a 2838...  If it is 2832u specific, then do you know which
product has it? It would be useful for me to have a usb stick with which I can
test SDR.

Secondly, this is a very awkward patch series to review, it really needs some
reorganization.

The rtl2832u_sdr driver is completely new, so just add the final version in one
single patch. I'm not interested in the intermediate steps as it is new anyway.

Any v4l core changes (new formats, docbook, controls, etc.) should come first in
the patch series so that driver patches can directly build on those. It's also
nice for me as a reviewer to have them first since core patches need more careful
review. Since all the core stuff is available for later driver patches, it is
probably also possible to merge patches together. E.g. instead of adding custom
support for a feature to a driver, then adding core support for it, then converting
the custom support to the core support in the driver, just can just add the new
feature directly using core support.

The reason is that it is hard to review core if you first see a half-finished
version and only later the final version (i.e. the one you really should be
reviewing).

I know, it's a lot of work but it pays itself by getting things merged much
quicker. As it stands now I am not going to review it, it's too messy.

Also, where possible group all patches modifying the same driver together, that
way I don't have to switch back-and-forth between drivers.

Oh, one thing I noticed in the rtl2832_sdr driver in the stop_streaming callback:
it can return an error. Be aware that the error code is not checked at all. The
stop_streaming callback really should be changed to a void function. Stopping
streaming is one of those things that should always succeed.

Regards,

	Hans

On 02/09/2014 09:48 AM, Antti Palosaari wrote:
> That is everything I have on my SDR queue. There is drivers for Mirics
> MSi3101 and Realtek RTL2832U based devices. These drivers are still on
> staging and I am not going to move those out of staging very soon as I
> want get some experiments first.
> 
> That set is available via Git:
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/sdr_review
> 
> 
> Simplest way to test it in practice is listen FM radio using SDRSharp as a radio player.
> I made simple plug-in for that:
> https://github.com/palosaari/sdrsharp-v4l2
> 
> That plug-in supports currently only on 64-bit Kernel...
> 
> 
> Installation is this simple (Fedora 20):
> 
> $ sudo yum install mono-core monodevelop
> $ svn co https://subversion.assembla.com/svn/sdrsharp/trunk sdrsharp
> $ cd sdrsharp
> $ git clone https://github.com/palosaari/sdrsharp-v4l2.git V4L2
> $ sed -i 's/Format Version 12\.00/Format Version 11\.00/' SDRSharp.sln
> 
> * Add following line to SDRSharp/App.config file inside frontendPlugins tag
>     <add key="Linux Kernel V4L2" value="SDRSharp.V4L2.LibV4LIO,SDRSharp.V4L2" />
> 
> $ monodevelop SDRSharp.sln
> * View > Default
> * Solution SDRSharp > Add > Add Existing Project... > V4L2 > SDRSharp.V4L2.csproj
> * Select Release|x86
> * Build > Build All
> * File > Quit
> $ mono Release/SDRSharp.exe
> 
> 
> regards
> Antti
> 
> 
> Antti Palosaari (85):
>   rtl2832_sdr: Realtek RTL2832 SDR driver module
>   rtl28xxu: attach SDR extension module
>   rtl2832_sdr: use config struct from rtl2832 module
>   rtl2832_sdr: initial support for R820T tuner
>   rtl2832_sdr: use get_if_frequency()
>   rtl2832_sdr: implement sampling rate
>   rtl2832_sdr: initial support for FC0012 tuner
>   rtl2832_sdr: initial support for FC0013 tuner
>   rtl28xxu: constify demod config structs
>   rtl2832: remove unused if_dvbt config parameter
>   rtl2832: style changes and minor cleanup
>   rtl2832_sdr: pixel format for SDR
>   rtl2832_sdr: implement FMT IOCTLs
>   msi3101: add signed 8-bit pixel format for SDR
>   msi3101: implement FMT IOCTLs
>   msi3101: move format 384 conversion to libv4lconvert
>   msi3101: move format 336 conversion to libv4lconvert
>   msi3101: move format 252 conversion to libv4lconvert
>   rtl28xxu: add module parameter to disable IR
>   rtl2832_sdr: increase USB buffers
>   rtl2832_sdr: convert to SDR API
>   msi3101: convert to SDR API
>   msi3101: add u8 sample format
>   msi3101: add u16 LE sample format
>   msi3101: tons of small changes
>   rtl2832_sdr: return NULL on rtl2832_sdr_attach failure
>   rtl2832_sdr: calculate bandwidth if not set by user
>   rtl2832_sdr: clamp ADC frequency to valid range always
>   rtl2832_sdr: improve ADC device programming logic
>   rtl2832_sdr: remove FMT buffer type checks
>   rtl2832_sdr: switch FM to DAB mode
>   msi3101: calculate tuner filters
>   msi3101: remove FMT buffer type checks
>   msi3101: improve ADC config stream format selection
>   msi3101: clamp ADC and RF to valid range
>   msi3101: disable all but u8 and u16le formats
>   v4l: add RF tuner gain controls
>   msi3101: use standard V4L gain controls
>   e4000: convert DVB tuner to I2C driver model
>   e4000: add manual gain controls
>   rtl2832_sdr: expose E4000 gain controls to user space
>   r820t: add manual gain controls
>   rtl2832_sdr: expose R820 gain controls to user space
>   e4000: fix PLL calc to allow higher frequencies
>   msi3101: fix device caps to advertise SDR receiver
>   rtl2832_sdr: fix device caps to advertise SDR receiver
>   msi3101: add default FMT and ADC frequency
>   msi3101: sleep USB ADC and tuner when streaming is stopped
>   DocBook: document RF tuner gain controls
>   DocBook: V4L: add V4L2_SDR_FMT_CU8 - 'CU08'
>   DocBook: V4L: add V4L2_SDR_FMT_CU16LE - 'CU16'
>   DocBook: media: document V4L2_CTRL_CLASS_RF_TUNER
>   xc2028: silence compiler warnings
>   v4l: add RF tuner channel bandwidth control
>   msi3101: implement tuner bandwidth control
>   rtl2832_sdr: implement tuner bandwidth control
>   msi001: Mirics MSi001 silicon tuner driver
>   msi3101: use msi001 tuner driver
>   MAINTAINERS: add msi001 driver
>   MAINTAINERS: add msi3101 driver
>   MAINTAINERS: add rtl2832_sdr driver
>   rtl28xxu: attach SDR module later
>   e4000: implement controls via v4l2 control framework
>   rtl2832_sdr: use E4000 tuner controls via V4L framework
>   e4000: remove .set_config() which was for controls
>   rtl28xxu: fix switch-case style issue
>   v4l: reorganize RF tuner control ID numbers
>   DocBook: document RF tuner bandwidth controls
>   v4l: uapi: add SDR formats CU8 and CU16LE
>   msi3101: use formats defined in V4L2 API
>   rtl2832_sdr: use formats defined in V4L2 API
>   v4l: add enum_freq_bands support to tuner sub-device
>   msi001: implement .enum_freq_bands()
>   msi3101: provide RF tuner bands from sub-device
>   r820t/rtl2832u_sdr: implement gains using v4l2 controls
>   v4l: add control for RF tuner PLL lock flag
>   e4000: implement PLL lock v4l control
>   DocBook: media: document PLL lock control
>   rtl2832: provide muxed I2C adapter
>   rtl2832: add muxed I2C adapter for demod itself
>   rtl2832: implement delayed I2C gate close
>   rtl28xxu: use muxed RTL2832 I2C adapters for E4000 and RTL2832_SDR
>   e4000: get rid of DVB i2c_gate_ctrl()
>   rtl2832_sdr: do not init tuner when only freq is changed
>   e4000: convert to Regmap API
> 
> Luis Alves (1):
>   rtl2832: Fix deadlock on i2c mux select function.
> 
>  Documentation/DocBook/media/v4l/controls.xml       |  119 ++
>  .../DocBook/media/v4l/pixfmt-sdr-cu08.xml          |   44 +
>  .../DocBook/media/v4l/pixfmt-sdr-cu16le.xml        |   46 +
>  Documentation/DocBook/media/v4l/pixfmt.xml         |    3 +
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 +-
>  MAINTAINERS                                        |   30 +
>  drivers/media/dvb-frontends/Kconfig                |    2 +-
>  drivers/media/dvb-frontends/rtl2832.c              |  191 ++-
>  drivers/media/dvb-frontends/rtl2832.h              |   34 +-
>  drivers/media/dvb-frontends/rtl2832_priv.h         |   54 +-
>  drivers/media/tuners/Kconfig                       |    1 +
>  drivers/media/tuners/e4000.c                       |  598 +++++---
>  drivers/media/tuners/e4000.h                       |   21 +-
>  drivers/media/tuners/e4000_priv.h                  |   86 +-
>  drivers/media/tuners/r820t.c                       |  137 +-
>  drivers/media/tuners/r820t.h                       |   10 +
>  drivers/media/tuners/tuner-xc2028.c                |    3 +
>  drivers/media/usb/dvb-usb-v2/Makefile              |    1 +
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   99 +-
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.h            |    2 +
>  drivers/media/v4l2-core/v4l2-ctrls.c               |   24 +
>  drivers/staging/media/Kconfig                      |    2 +
>  drivers/staging/media/Makefile                     |    2 +
>  drivers/staging/media/msi3101/Kconfig              |    7 +-
>  drivers/staging/media/msi3101/Makefile             |    1 +
>  drivers/staging/media/msi3101/msi001.c             |  499 +++++++
>  drivers/staging/media/msi3101/sdr-msi3101.c        | 1558 +++++++-------------
>  drivers/staging/media/rtl2832u_sdr/Kconfig         |    7 +
>  drivers/staging/media/rtl2832u_sdr/Makefile        |    6 +
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c   | 1476 +++++++++++++++++++
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h   |   51 +
>  include/media/v4l2-subdev.h                        |    1 +
>  include/uapi/linux/v4l2-controls.h                 |   14 +
>  include/uapi/linux/videodev2.h                     |    4 +
>  34 files changed, 3825 insertions(+), 1315 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml
>  create mode 100644 drivers/staging/media/msi3101/msi001.c
>  create mode 100644 drivers/staging/media/rtl2832u_sdr/Kconfig
>  create mode 100644 drivers/staging/media/rtl2832u_sdr/Makefile
>  create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
>  create mode 100644 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h
> 

