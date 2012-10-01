Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54494 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab2JATi3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 15:38:29 -0400
Message-ID: <5069F11F.40104@iki.fi>
Date: Mon, 01 Oct 2012 22:38:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.7] all the rest patches!
References: <5064CFEF.7040301@iki.fi> <50657B0C.70706@iki.fi> <506740E5.1030708@iki.fi> <20121001163225.67ff5319@redhat.com>
In-Reply-To: <20121001163225.67ff5319@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/01/2012 10:32 PM, Mauro Carvalho Chehab wrote:
> Em Sat, 29 Sep 2012 21:41:41 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Updated, one new USB ID for RTL2832U.
>>
>> The following changes since commit 8928b6d1568eb9104cc9e2e6627d7086437b2fb3:
>>
>>     [media] media: mx2_camera: use managed functions to clean up code
>> (2012-09-27 15:56:47 -0300)
>>
>> are available in the git repository at:
>>
>>     git://linuxtv.org/anttip/media_tree.git for_v3.7_mauro-3
>>
>> for you to fetch changes up to bf342b50ac6c5801a95d6a089086587446c8d6cf:
>>
>>     rtl28xxu: [0ccd:00d3] TerraTec Cinergy T Stick RC (Rev. 3)
>> (2012-09-29 21:39:26 +0300)
>>
>> ----------------------------------------------------------------
>> Antti Palosaari (5):
>>         em28xx: implement FE set_lna() callback
>>         cxd2820r: use static GPIO config when GPIOLIB is undefined
>>         em28xx: do not set PCTV 290e LNA handler if fe attach fail
>>         em28xx: PCTV 520e workaround for DRX-K fw loading
>
> All applied except for the above.
>
> As I said before: sleeping for 2 seconds doesn't give any warranty that
> the firmware got loaded (and I know one system where firmware load generally
> takes more than 2 seconds to start - probably because the root fs is using
> nfs, and the machine uses an Atom single core processor).
>
> As I've explained, if the driver needs to wait for a firmware load, it
> should use something that will actually wait for firmware load to complete,
> instead of just sleeping in the hope that the amount of sleeping time would
> be enough.

Yes I certainly know. My aim was to provide working driver around 99% of 
users even it is not correct. I don't understand why you all the time 
reject this kind of workarounds leaving devices 100% non-working state. 
And as it is the device what I am mostly responsible, I will get all the 
angry feedback from the unhappy users as their device does not work 
anymore after the Kernel upgrade.

regards
Antti

-- 
http://palosaari.fi/
