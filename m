Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:46589 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbZA2NIQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 08:08:16 -0500
Date: Thu, 29 Jan 2009 14:08:01 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: matthieu castet <castet.matthieu@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Support faulty USB IDs on DIBUSB_MC
In-Reply-To: <20090129100520.3331f41f@caramujo.chehab.org>
Message-ID: <alpine.LRH.1.10.0901291329590.15700@pub6.ifh.de>
References: <484A72D3.7070500@free.fr> <4974E4BE.2060107@free.fr> <20090129074735.76e07d47@caramujo.chehab.org> <alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de> <20090129100520.3331f41f@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009, Mauro Carvalho Chehab wrote:
>> We could do that, still I'm not sure if ARRAY_SIZE will work in that
>> situation?! Are you
>> sure, Mauro?
>
> Well, at least here, it is compiling fine. I can't really test it, since I
> don't have any dib0700 devices here.

Hmm, your patch is shifting the counting problem to another place. Instead 
of counting manually the devices-array-elements, one now needs to count 
the number of device_properties ;) .

With such a patch we would risk to break some device support and as I 
never saw a patch which broke the current num_device_descs-manual-count I 
don't see the need to change.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
