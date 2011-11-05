Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.services.sfr.fr ([93.17.128.1]:23160 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab1KERUa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Nov 2011 13:20:30 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2119.sfr.fr (SMTP Server) with ESMTP id 2546170001E2
	for <linux-media@vger.kernel.org>; Sat,  5 Nov 2011 18:20:27 +0100 (CET)
Received: from smtp-in.softsystem.co.uk (183.95.30.93.rev.sfr.net [93.30.95.183])
	by msfrf2119.sfr.fr (SMTP Server) with SMTP id D68AC70001B6
	for <linux-media@vger.kernel.org>; Sat,  5 Nov 2011 18:20:26 +0100 (CET)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.30.95.183] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sat, 05 Nov 2011 18:20:25 +0100
Subject: Re: [PATCH] Revert most of 15cc2bb [media] DVB:
 dtv_property_cache_submit shouldn't modifiy the cache
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4EB566CD.7050704@linuxtv.org>
References: <1320506379.1731.12.camel@gagarin>
	 <4EB566CD.7050704@linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Nov 2011 18:20:24 +0100
Message-ID: <1320513624.1731.20.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-11-05 at 17:39 +0100, Andreas Oberritter wrote:
[snip]
> How does MythTV set the parameters (i.e. using which interface, calls)?
> If using S2API, it should also set DTV_DELIVERY_SYSTEM.

The following kern.log excerpt shows MythTV setting up the card:

Nov  5 11:54:52 cyclops kernel: [ 4139.489804] dvb_frontend_ioctl (82)  FE_SET_PROPERTY
Nov  5 11:54:52 cyclops kernel: [ 4139.489806] dvb_frontend_ioctl_properties
Nov  5 11:54:52 cyclops kernel: [ 4139.489808] dvb_frontend_ioctl_properties() properties.num = 1
Nov  5 11:54:52 cyclops kernel: [ 4139.489810] dvb_frontend_ioctl_properties() properties.props = bf95ec24
Nov  5 11:54:52 cyclops kernel: [ 4139.489813] dtv_property_dump() tvp.cmd    = 0x00000002 (DTV_CLEAR)
Nov  5 11:54:52 cyclops kernel: [ 4139.489814] dtv_property_dump() tvp.u.data = 0xb7819a31
Nov  5 11:54:52 cyclops kernel: [ 4139.489816] dtv_property_process_set() Flushing property cache
Nov  5 11:54:52 cyclops kernel: [ 4139.489841] dvb_frontend_ioctl (82) FE_SET_PROPERTY
Nov  5 11:54:52 cyclops kernel: [ 4139.489842] dvb_frontend_ioctl_properties
Nov  5 11:54:52 cyclops kernel: [ 4139.489843] dvb_frontend_ioctl_properties() properties.num = 7
Nov  5 11:54:52 cyclops kernel: [ 4139.489844] dvb_frontend_ioctl_properties() properties.props = 0a0acab0
Nov  5 11:54:52 cyclops kernel: [ 4139.489846] dtv_property_dump() tvp.cmd    = 0x00000011 (DTV_DELIVERY_SYSTEM)
Nov  5 11:54:52 cyclops kernel: [ 4139.489848] dtv_property_dump() tvp.u.data = 0x00000000
Nov  5 11:54:52 cyclops kernel: [ 4139.489850] dtv_property_dump() tvp.cmd    = 0x00000003 (DTV_FREQUENCY)
Nov  5 11:54:52 cyclops kernel: [ 4139.489851] dtv_property_dump() tvp.u.data = 0x0010104e
Nov  5 11:54:52 cyclops kernel: [ 4139.489853] dtv_property_dump() tvp.cmd    = 0x00000004 (DTV_MODULATION)
Nov  5 11:54:52 cyclops kernel: [ 4139.489854] dtv_property_dump() tvp.u.data = 0x00000000
Nov  5 11:54:52 cyclops kernel: [ 4139.489856] dtv_property_dump() tvp.cmd    = 0x00000006 (DTV_INVERSION)
Nov  5 11:54:52 cyclops kernel: [ 4139.489857] dtv_property_dump() tvp.u.data = 0x00000002
Nov  5 11:54:52 cyclops kernel: [ 4139.489859] dtv_property_dump() tvp.cmd    = 0x00000008 (DTV_SYMBOL_RATE)
Nov  5 11:54:52 cyclops kernel: [ 4139.489860] dtv_property_dump() tvp.u.data = 0x014fb180
Nov  5 11:54:52 cyclops kernel: [ 4139.489861] dtv_property_dump() tvp.cmd    = 0x00000009 (DTV_INNER_FEC)
Nov  5 11:54:52 cyclops kernel: [ 4139.489863] dtv_property_dump() tvp.u.data = 0x00000009
Nov  5 11:54:52 cyclops kernel: [ 4139.489864] dtv_property_dump() tvp.cmd    = 0x00000001 (DTV_TUNE)
Nov  5 11:54:52 cyclops kernel: [ 4139.489866] dtv_property_dump() tvp.u.data = 0x00000000
Nov  5 11:54:52 cyclops kernel: [ 4139.489867] dtv_property_process_set() Finalised property cache
Nov  5 11:54:52 cyclops kernel: [ 4139.489869] dtv_property_cache_submit() legacy, modulation = 0
Nov  5 11:54:52 cyclops kernel: [ 4139.489870] dtv_property_legacy_params_sync() Preparing QPSK req
Nov  5 11:54:52 cyclops kernel: [ 4139.489879] dvb_frontend_add_event
Nov  5 11:54:52 cyclops kernel: [ 4139.489880] dvb_frontend_ioctl_properties() Property cache is full, tuning
Nov  5 11:54:52 cyclops kernel: [ 4139.489897] dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_HW
Nov  5 11:54:52 cyclops kernel: [ 4139.489899] dvb_frontend_poll
Nov  5 11:54:52 cyclops kernel: [ 4139.489902] dvb_frontend_thread: Retune requested, FESTATE_RETUNE
Nov  5 11:54:52 cyclops kernel: [ 4139.489903] dvb_frontend_ioctl (69)  FE_READ_STATUS
Nov  5 11:54:52 cyclops kernel: [ 4139.489907] TurboSight TBS 6981 Frontend:
Nov  5 11:54:52 cyclops kernel: [ 4139.489907]  tbs6981fe - delivery system 0 is not supported

Note that DTV_DELIVERY_SYSTEM is set to 0 which worked OK in 2.6.39

> SYS_UNDEFINED get's set by dvb_frontend_clear_cache() only. I think it
> would be better to call dtv_property_cache_init() from there to get rid
> of it.

That doesn't fix this problem, which is explicitly setting
DTV_DELIVERY_SYSTEM.  A value of 0 (SYS_UNDEFINED) was accepted before
this change and should continue to be accepted.  In
dtv_property_cache_submit the comment reads:

/* For legacy delivery systems we don't need the delivery_system to
 * be specified, but we populate the older structures from the cache
 * so we can call set_frontend on older drivers.
 */

-- 
Lawrence
