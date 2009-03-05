Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:62926 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbZCELZB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 06:25:01 -0500
Received: from pub6.ifh.de (pub6.ifh.de [141.34.15.118])
	by znsun1.ifh.de (8.12.11.20060614/8.12.11) with ESMTP id n25BOrvA003882
	for <linux-media@vger.kernel.org>; Thu, 5 Mar 2009 12:24:53 +0100 (MET)
Received: from localhost (localhost [127.0.0.1])
	by pub6.ifh.de (Postfix) with ESMTP id 341AC300136
	for <linux-media@vger.kernel.org>; Thu,  5 Mar 2009 12:24:53 +0100 (CET)
Date: Thu, 5 Mar 2009 12:24:53 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] ERROR: Module dvb_usb_aaa_dvbusb_demo is in use
In-Reply-To: <12093750.396551236251196232.JavaMail.coremail@bj163app172.163.com>
Message-ID: <alpine.LRH.1.10.0903051218410.30470@pub6.ifh.de>
References: <12093750.396551236251196232.JavaMail.coremail@bj163app172.163.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="579696143-1088822750-1236251925=:30470"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--579696143-1088822750-1236251925=:30470
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT

Hi,

On Thu, 5 Mar 2009, wdy9927 wrote:
> I had make install a module for a dvb usb box which writen by my self. But this one didn't have real frontend ops and tuner ops.These functions did
> nothing but return 0.
> Like this
> static int demo_fe_init(struct dvb_frontend *fe)
> {
>     return 0;
> }
> 
> After the usb box removed from linux, the DVB system called demo_fe_release and demo_tu_release, sofar that seems very good? But, I can't rmmod this
> module normally. It showed "ERROR: Module dvb_usb_dvbusb_demo is in use".This error is diffrent with "ERROR: Module dvb_usb is in use by
> dvb_usb_dvbusb_demo"
> 
> How can i rmmod this module with out reboot Linux.

This is a known problem with every dvb-device-driver (especially the ones 
using dvb-usb) which are implementing the frontend-part not as an 
independent kernel module. When the frontend-driver is "released" the 
dvb-core is doing something like use-count-decrement on the module. As the 
use-count was never incremented (dvb_attach cannot be used on function 
which are not exported with EXPORT_SYMBOL) the count is now -1, which is 
same as 0xffffffff.

rmmod is refusing to unload a module which has a use_count != 0. This is 
the problem you're facing.

You could still try to use rmmod -f to force to unload. Or you make your 
frontend-driver a seperate kernel module.

Patrick.
--579696143-1088822750-1236251925=:30470--
