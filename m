Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:50242 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbaCWKKI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Mar 2014 06:10:08 -0400
Message-ID: <532EB2FE.2020606@schinagl.nl>
Date: Sun, 23 Mar 2014 11:10:06 +0100
From: Olliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>,
	Simon Liddicott <simon@liddicott.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Updated DVB-T tables - where to send them?
References: <1395099887.87256.YahooMailNeo@web120305.mail.ne1.yahoo.com> <CALuNSF76RLkVRfBCr10N4U1i4U1BCrd5A5uqB6aqZ_9kVd_UFQ@mail.gmail.com> <1395134694.52130.YahooMailNeo@web120303.mail.ne1.yahoo.com>
In-Reply-To: <1395134694.52130.YahooMailNeo@web120303.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/18/2014 10:24 AM, Chris Rankin wrote:
> Hi,
>
>
> Fedora 20 is using a new dvb-scan-tables package:
>
> * Mon Jan 13 2014 Till Maas <opensource@till.name> - 0-4.20130713gitd913405
>
> Unfortunately, it's still full of files dating from 2012! I will raise a bug in their bugzilla for them to ignore completely and then close when Fedora 22 is released.
Till e-mailed me not to long ago asking me to fix something in the 
dvb-apps package so he could repackage a bunch of things. So it might be 
available soon.

That said, the downloads section of linux tv only lists 1 ancient 
'named' package, the latest one is up to date.

I'll ping mauro about the packages to get those fixed again, but the 
-LATEST should contain anything that is in the git repo. If there is 
anything still wrong or missing, a patch here, or a Pullrequest even, 
will make it merged quickly :)

Olliver
>
> Cheers,
> Chris
>
>
> On Tuesday, 18 March 2014, 9:07, Simon Liddicott <simon@liddicott.com> wrote:
>
>> I submitted updates for the whole of the UK in September.
>> Check Crystal Palace here: <http://git.linuxtv.org/dtv-scan-tables.git/blob_plain/HEAD:/dvb-t/uk-CrystalPalace>
>>
>> You will probably find your distro hasn't updated.
>>
>> I did a pull request into this github repo <https://github.com/oliv3r/dtv-scan-tables>
>>
>> Si.
>
>
>
> On 17 March 2014 23:44, Chris Rankin <rankincj@yahoo.com> wrote:
>
>
>>
>> Hi,
>>
>> The DVB-T initial tuning information for Crystal Palace in the UK is completely obsolete - despite my two attempts to submit an updated version over the YEARS. Where is the best place to send this information, please?
>>
>> Thanks,
>> Chris
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

