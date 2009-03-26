Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:62283 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbZCZQpW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 12:45:22 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KH4003F0H7IRQ40@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 26 Mar 2009 12:45:19 -0400 (EDT)
Date: Thu, 26 Mar 2009 12:45:18 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [PATCH] Allow the user to restrict the RC5 address
In-reply-to: <200903260824.01970.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Udo A. Steinberg" <udo@hypervisor.org>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	Darron Broad <darron@kewl.org>,
	"v4l-dvb-maintainer@linuxtv.org" <v4l-dvb-maintainer@linuxtv.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <49CBB11E.2030604@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20090326033453.7d90236d@laptop.hypervisor.org>
 <200903260824.01970.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Thursday 26 March 2009 03:34:53 Udo A. Steinberg wrote:
>   
>> Mauro,
>>
>> This patch allows users with multiple remotes to specify an RC5 address
>> for a remote from which key codes will be accepted. If no address is
>> specified, the default value of 0 accepts key codes from any remote. This
>> replaces the current hard-coded address checks, which are too
>> restrictive.
>>     
>
> I think this should be reviewed by Steve Toth first (CC-ed him).
>
> One thing that this patch breaks is if you have multiple Hauppauge remotes, 
> some sending 0x1e, some 0x1f. With this patch I can't use both, only one.
>
>   
Hans, thanks for bringing this to my attention.

Mauro, This patch is a regression, although a small one. it probably 
needs a little more work.

I too tend to have multiple remotes, I don't think it's that unusual for 
long standing Hauppauge customers to have many boards with many types of 
remotes.

> It might be better to have an option to explicitly allow old Hauppauge 
> remotes that send 0x00.
>
>   
I could live with this. It relegates older remotes but those remotes are 
no longer made. This feels like a good compromise.

- Steve
