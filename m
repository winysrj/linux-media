Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32893 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752327AbcJWSFT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 14:05:19 -0400
Subject: Re: [PATCH v3 0/2] media: add et8ek8 camera sensor driver and
 documentation
To: Pavel Machek <pavel@ucw.cz>
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20161023073322.GA3523@amd>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <53284bf5-9a36-fbcb-5cac-4a64823c3516@gmail.com>
Date: Sun, 23 Oct 2016 21:05:14 +0300
MIME-Version: 1.0
In-Reply-To: <20161023073322.GA3523@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 23.10.2016 10:33, Pavel Machek wrote:
> Hi!
>
>> This series adds driver for Toshiba et8ek8 camera sensor found in Nokia N900
>>
>> Changes from v2:
>>
>>  - fix build when CONFIG_PM is not defined
>>
>> Changes from v1:
>>
>>  - driver and documentation split into separate patches
>>  - removed custom controls
>>  - code changed according to the comments on v1
>
>> Ivaylo Dimitrov (2):
>>   media: Driver for Toshiba et8ek8 5MP sensor
>>   media: et8ek8: Add documentation
>
> Is there any progress here? Is there any way I could help?
>

There were some notes I need to address, unfortunately no spare time 
lately :( . Feel free to fix those for me and resend the patches. If 
not, I really don't know when I will have the time needed to focus on it.

Regards,
Ivo
