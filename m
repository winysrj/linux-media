Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34695 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab2GCVrZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Jul 2012 17:47:25 -0400
Message-ID: <4FF36865.1090808@iki.fi>
Date: Wed, 04 Jul 2012 00:47:17 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.6] DVB USB v2
References: <4FF19D3C.6070506@iki.fi>
In-Reply-To: <4FF19D3C.6070506@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/02/2012 04:08 PM, Antti Palosaari wrote:
> Here it is finally - quite totally rewritten DVB-USB-framework. I
> haven't got almost any feedback so far...

I rebased it in order to fix compilation issues coming from Kconfig.


> regards
> Antti
>
>
> The following changes since commit
> 6887a4131da3adaab011613776d865f4bcfb5678:
>
>    Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)
>
> are available in the git repository at:
>
>    git://linuxtv.org/anttip/media_tree.git dvb_usb_pull
>
> for you to fetch changes up to 747abaa1e0ee4415e67026c119cb73e6277f4898:
>
>    dvb_usb_v2: remove usb_clear_halt() from stream (2012-07-02 15:54:29
> +0300)
>
> ----------------------------------------------------------------
> Antti Palosaari (103):
>        dvb_usb_v2: copy current dvb_usb as a starting point
>        dvb_usb_v2: add .init() callback
>        dvb_usb_v2: remove one parameter from dvb_usbv2_device_init()
>        dvb_usb_v2: use .driver_info to pass struct
> dvb_usb_device_properties
>        dvb_usb_v2: remove owner parameter from dvb_usbv2_device_init()
>        dvb_usb_v2: remove adapter_nums parameter from
> dvb_usbv2_device_init()
>        dvb_usb_v2: pass (struct dvb_usb_device *) as a parameter for fw
> download
>        dvb_usb_v2: implement .get_firmware_name()
>        dvb_usb_v2: fix issues raised by checkpatch.pl
>        dvb_usb_v2: pass device name too using (struct usb_device_id)
>        dvb_usb_v2: implement .get_adapter_count()
>        dvb_usb_v2: implement .read_config()
>        dvb_usb_v2: remote controller
>        dvb_usb_v2: restore .firmware - pointer to name
>        dvb_usb_v2: init I2C and USB mutex earlier
>        dvb_usb_v2: remote controller changes
>        dvb_usb_v2: dynamic USB stream URB configuration
>        dvb_usb_v2: usb_urb.c use dynamic debugs
>        dvb_usb_v2: add .get_usb_stream_config()
>        dvb_usb_v2: move (struct usb_data_stream) to one level up
>        dvb_usb_v2: add .get_ts_config() callback
>        dvb_usb_v2: move (struct usb_data_stream_properties) to upper level
>        dvb_usb_v2: move PID filters from frontend to adapter
>        dvb_usb_v2: move 3 callbacks from the frontend to adapter
>        dvb_usb_v2: get rid of (struct dvb_usb_adapter_fe_properties)
>        dvb_usb_v2: remove .num_frontends
>        dvb_usb_v2: delay firmware download as it blocks module init
>        dvb_usb_v2: clean firmware downloading routines
>        dvb_usb_v2: add macro for filling usb_device_id table entry
>        dvb_usb_v2: use dynamic debugs
>        dvb_usb_v2: remove various unneeded variables
>        dvb_usb_v2: frontend switching changes
>        dvb_usb_v2: ensure driver_info is not null
>        dvb_usb_v2: refactor delayed init
>        dvb_usb_v2: remove usb_clear_halt()
>        dvb_usb_v2: unregister all frontends in error case
>        dvb_usb_v2: use Kernel logging (pr_debug/pr_err/pr_info)
>        dvb_usb_v2: move I2C adapter code to different file
>        dvb_usb_v2: rename device_init/device_exit to probe/disconnect
>        dvb_usb_v2: add .bInterfaceNumber match
>        dvb_usb_v2: add missing new line for log writings
>        dvb_usb_v2: fix dvb_usb_generic_rw() debug
>        af9015: switch to new DVB-USB
>        dvb_usb_v2: do not free resources until delayed init is done
>        af9015: use USB core soft_unbind
>        dvb_usb_v2: I2C adapter changes
>        dvb_usb_v2: misc changes
>        dvb_usb_v2: probe/disconnect error handling
>        dvb_usb_v2: add .disconnect() callback
>        dvb_usb_v2: suspend/resume stop/start USB streaming
>        dvb_usb_v2: Cypress firmware download module
>        dvb_usb_v2: move few callbacks one level up
>        dvb_usb_v2: use keyword const for USB ID table
>        af9015: suspend/resume
>        dvb_usb_v2: use pointers to properties
>        ec168: convert to new DVB USB
>        ec168: switch Kernel pr_* logging
>        dvb_usb_v2: do not check active fe when stop streaming
>        ec168: re-implement firmware loading
>        au6610: convert to new DVB USB
>        dvb_usb_v2: move remote controller to the main file
>        ce6230: convert to new DVB USB
>        ce6230: various small changes
>        dvb_usb_v2: attach tuners later
>        anysee: convert to new DVB USB
>        dvb_usb_v2: do not release USB interface when device reconnects
>        dvb_usb_v2: try to remove all adapters on exit
>        dvb_usb_v2: simplify remote init/exit logic
>        dvb_usb_v2: get rid of dvb_usb_device state
>        dvb_usb_v2: move fe_ioctl_override() callback
>        dvb_usb_v2: remove num_frontends_initialized from dvb_usb_adapter
>        dvb_usb_v2: .read_mac_address() callback changes
>        dvb_usb_v2: add macros to fill USB stream properties
>        dvb_usb_v2: change USB stream config logic
>        af9015: update USB streaming configuration logic
>        dvb_usb_v2: helper macros for device/adapter/frontend pointers
>        af9015: use helper macros for some pointers
>        dvb_usb_v2: use lock to sync feed and frontend control
>        af9035: convert to new DVB USB
>        dvb_usb_v2: git rid of dvb_usb_adapter state variable
>        anysee: use DVB USB macros
>        au6610: use DVB USB macros
>        ce6230: use DVB USB macros
>        ec168: use DVB UDB macros
>        dvb_usb_v2: use container_of() for adapter to device
>        dvb_usb_v2: merge get_ts_config() to get_usb_stream_config()
>        dvb_usb_v2: use identify_state() to resolve firmware name
>        dvb_usb_v2: remove num_adapters_initialized variable
>        dvb_usb_v2: refactor dvb_usb_ctrl_feed() logic
>        dvb_usb_v2: merge files dvb_usb_init.c and dvb_usb_dvb.c
>        dvb_usb_v2: move dvb_usbv2_generic_rw() debugs behind define
>        dvb_usb_v2: multiple small tweaks around the code
>        dvb_usb_v2: refactor dvb_usbv2_generic_rw()
>        dvb_usb_v2: update header dvb_usb.h comments
>        dvb_usb_v2: remove unused variable
>        dvb_usb_v2: update copyrights
>        dvb_usb_v2: fix power_ctrl() callback error handling
>        dvb_usb_v2: change streaming control callback parameter
>        mxl111sf: convert to new DVB USB
>        gl861: convert to new DVB USB
>        dvb_usb_v2: use dev_* logging macros
>        dvb_usb_v2: do not try to remove non-existent adapter
>        dvb_usb_v2: remove usb_clear_halt() from stream
>
> Malcolm Priestley (1):
>        dvb_usb_v2: return the download ret in dvb_usb_download_firmware
>
>   drivers/media/dvb/dvb-usb/Kconfig            |   19 ++
>   drivers/media/dvb/dvb-usb/Makefile           |    5 +
>   drivers/media/dvb/dvb-usb/af9015.c           | 2072
> +++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------
>
>   drivers/media/dvb/dvb-usb/af9015.h           |   67 ++++-
>   drivers/media/dvb/dvb-usb/af9035.c           |  727
> ++++++++++++++++++----------------------------
>   drivers/media/dvb/dvb-usb/af9035.h           |    6 +-
>   drivers/media/dvb/dvb-usb/anysee.c           |  612
> +++++++++++++++++----------------------
>   drivers/media/dvb/dvb-usb/anysee.h           |   26 +-
>   drivers/media/dvb/dvb-usb/au6610.c           |  116 +++-----
>   drivers/media/dvb/dvb-usb/au6610.h           |   13 +-
>   drivers/media/dvb/dvb-usb/ce6230.c           |  181 +++++-------
>   drivers/media/dvb/dvb-usb/ce6230.h           |   36 +--
>   drivers/media/dvb/dvb-usb/dvb_usb.h          |  392
> +++++++++++++++++++++++++
>   drivers/media/dvb/dvb-usb/dvb_usb_common.h   |   35 +++
>   drivers/media/dvb/dvb-usb/dvb_usb_core.c     |  996
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/media/dvb/dvb-usb/dvb_usb_firmware.c |  125 ++++++++
>   drivers/media/dvb/dvb-usb/dvb_usb_firmware.h |   31 ++
>   drivers/media/dvb/dvb-usb/dvb_usb_urb.c      |   83 ++++++
>   drivers/media/dvb/dvb-usb/ec168.c            |  321 +++++++++------------
>   drivers/media/dvb/dvb-usb/ec168.h            |   26 +-
>   drivers/media/dvb/dvb-usb/gl861.c            |  130 +++------
>   drivers/media/dvb/dvb-usb/gl861.h            |    5 +-
>   drivers/media/dvb/dvb-usb/mxl111sf-tuner.c   |    2 +
>   drivers/media/dvb/dvb-usb/mxl111sf.c         | 1456
> +++++++++++++++++++++++++++++++++++---------------------------------------------------------
>
>   drivers/media/dvb/dvb-usb/mxl111sf.h         |   22 +-
>   drivers/media/dvb/dvb-usb/usb_urb.c          |  357
> +++++++++++++++++++++++
>   26 files changed, 4306 insertions(+), 3555 deletions(-)
>   create mode 100644 drivers/media/dvb/dvb-usb/dvb_usb.h
>   create mode 100644 drivers/media/dvb/dvb-usb/dvb_usb_common.h
>   create mode 100644 drivers/media/dvb/dvb-usb/dvb_usb_core.c
>   create mode 100644 drivers/media/dvb/dvb-usb/dvb_usb_firmware.c
>   create mode 100644 drivers/media/dvb/dvb-usb/dvb_usb_firmware.h
>   create mode 100644 drivers/media/dvb/dvb-usb/dvb_usb_urb.c
>   create mode 100644 drivers/media/dvb/dvb-usb/usb_urb.c
>


-- 
http://palosaari.fi/


