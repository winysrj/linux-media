Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:60596 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751648AbdE0J1M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 May 2017 05:27:12 -0400
Subject: Re: [patch, libv4l]: add sdlcam example for testing digital still
 camera functionality
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
References: <20170424103802.00d3b554@vento.lan> <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan> <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan> <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com> <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl> <20170521103315.GA10716@amd>
 <20170526204102.GA22860@amd>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e9763254-bcb4-c469-297f-7e7530f4edb0@xs4all.nl>
Date: Sat, 27 May 2017 11:27:04 +0200
MIME-Version: 1.0
In-Reply-To: <20170526204102.GA22860@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/26/2017 10:41 PM, Pavel Machek wrote:
> Hi!
> 
>> Add simple SDL-based application for capturing photos. Manual
>> focus/gain/exposure can be set, flash can be controlled and
>> autofocus/autogain can be selected if camera supports that.
>>
>> It is already useful for testing autofocus/autogain improvements to
>> the libraries on Nokia N900.
>>
>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> Could I get some feedback here, or get you to apply the patch?

I plan to look at it next week (Monday or Friday).

Regards,

	Hans
