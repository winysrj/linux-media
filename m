Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0EHB2b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 May 2010 21:28:31 -0400
Message-ID: <4BE4BE38.2040303@redhat.com>
Date: Fri, 07 May 2010 22:28:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: Status of the patches under review (85 patches) and some misc
 	notes about the devel procedures
References: <20100507093916.2e2ef8e3@pedra> <q2p1a297b361005070615i310a285al522475ec6405b53@mail.gmail.com>
In-Reply-To: <q2p1a297b361005070615i310a285al522475ec6405b53@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:
> On Fri, May 7, 2010 at 4:39 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Hi,
>>
> 
>> This is the summary of the patches that are currently under review.
>> Each patch is represented by its submission date, the subject (up to 70
>> chars) and the patchwork link (if submitted via email).
>>
> 
>>                == Port mantis IR to the new API - waiting for Manu Abraham <abraham.manu@gmail.com> ack or alternative patch ==
>>
>> Apr,15 2010: [5/8] ir-core: convert mantis from ir-functions.c
> 
> 
> This needs to wait for an alternate patch, which depends on
> linuxtv.org/hg/v4l-dvb proper build

Ok. I think Douglas already backported the IR changes. Not sure if his tree
is now in sync with git.

-- 

Cheers,
Mauro
