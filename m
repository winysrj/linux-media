Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm45.bullet.mail.ne1.yahoo.com ([98.138.120.52]:41468 "HELO
	nm45.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754601AbaCRJ1u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 05:27:50 -0400
References: <1395099887.87256.YahooMailNeo@web120305.mail.ne1.yahoo.com> <CALuNSF76RLkVRfBCr10N4U1i4U1BCrd5A5uqB6aqZ_9kVd_UFQ@mail.gmail.com>
Message-ID: <1395134694.52130.YahooMailNeo@web120303.mail.ne1.yahoo.com>
Date: Tue, 18 Mar 2014 02:24:54 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Updated DVB-T tables - where to send them?
To: Simon Liddicott <simon@liddicott.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <CALuNSF76RLkVRfBCr10N4U1i4U1BCrd5A5uqB6aqZ_9kVd_UFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


Fedora 20 is using a new dvb-scan-tables package:

* Mon Jan 13 2014 Till Maas <opensource@till.name> - 0-4.20130713gitd913405

Unfortunately, it's still full of files dating from 2012! I will raise a bug in their bugzilla for them to ignore completely and then close when Fedora 22 is released.

Cheers,
Chris


On Tuesday, 18 March 2014, 9:07, Simon Liddicott <simon@liddicott.com> wrote:

> I submitted updates for the whole of the UK in September. 
> Check Crystal Palace here: <http://git.linuxtv.org/dtv-scan-tables.git/blob_plain/HEAD:/dvb-t/uk-CrystalPalace>
> 
> You will probably find your distro hasn't updated.
> 
> I did a pull request into this github repo <https://github.com/oliv3r/dtv-scan-tables> 
> 
> Si.



On 17 March 2014 23:44, Chris Rankin <rankincj@yahoo.com> wrote:


>
>Hi,
>
>The DVB-T initial tuning information for Crystal Palace in the UK is completely obsolete - despite my two attempts to submit an updated version over the YEARS. Where is the best place to send this information, please?
>
>Thanks,
>Chris
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
