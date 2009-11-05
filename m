Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp19.orange.fr ([80.12.242.17]:14316 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038AbZKENq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 08:46:26 -0500
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] How to create a filter which can filte a whole packet(188 byte with 0x47)
Date: Thu, 5 Nov 2009 14:47:36 +0100
References: <25694071.578071257426933010.JavaMail.coremail@app179.163.com>
In-Reply-To: <25694071.578071257426933010.JavaMail.coremail@app179.163.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911051447.36377.hftom@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 5 novembre 2009 14:15:33, wdy9927 a écrit :
> it seems like the sec_filter and the pes_filter cann't do that.
> is there other ways?
> 

This should do what you want:

struct dmx_pes_filter_params pesFilterParams;
dmx_pes_type_t pestype = DMX_PES_OTHER;
int dmx = open("/dev/dvb/adapter0/demux0", O_RDWR | O_NONBLOCK );
pesFilterParams.pid = pid;
pesFilterParams.input = DMX_IN_FRONTEND;
pesFilterParams.output = DMX_OUT_TAP;
pesFilterParams.pes_type = pestype;
pesFilterParams.flags = DMX_IMMEDIATE_START;
ioctl( dmx, DMX_SET_PES_FILTER, &pesFilterParams);

-- 
Christophe Thommeret


