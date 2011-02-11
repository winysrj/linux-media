Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787Ab1BKTWx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Feb 2011 14:22:53 -0500
Message-ID: <4D558C69.2010109@redhat.com>
Date: Fri, 11 Feb 2011 17:22:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: "X.Org Devel List" <xorg-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dmitry Butskoy <buc@odusz.so-cdu.ru>
Subject: Re: [PATCH 0/8] Port xf86-video-v4l driver to V4L2 version 2
References: <20110211135425.6441a750@pedra> <AANLkTimWFVj-v3QOyTVhquQQKVy_PO+q3dkPmY6_UGJT@mail.gmail.com>
In-Reply-To: <AANLkTimWFVj-v3QOyTVhquQQKVy_PO+q3dkPmY6_UGJT@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Alex,

Em 11-02-2011 15:37, Alex Deucher escreveu:
> On Fri, Feb 11, 2011 at 10:54 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> This is the second version of my backport patches. To avoid spending
>> people's time on looking at lines that have only whitespace changes,
>> I broke the patch I submitted two days ago into two patches:
>> the first one with just the logical changes, and the second one with
>> just CodingStyle (whitespace) fixes.
> 
> Mauro,  I don't think anyone has maintained or used the v4l module in
> ages.  You could be the new maintainer :)
> Or at least have commit rights.  Just follow the instructions here:
> http://www.freedesktop.org/wiki/AccountRequests

Thanks for the tip! I've filled an account request there.

Thanks!
Mauro
