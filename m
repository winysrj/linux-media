Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab2AJWWY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 17:22:24 -0500
Message-ID: <4F0CBA13.7080305@redhat.com>
Date: Tue, 10 Jan 2012 20:22:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] Fix dvb-core set_delivery_system and port drxk to
 one frontend
References: <1325777872-14696-1-git-send-email-mchehab@redhat.com> <4F0CB197.5010306@iki.fi>
In-Reply-To: <4F0CB197.5010306@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10-01-2012 19:45, Antti Palosaari wrote:
> On 01/05/2012 05:37 PM, Mauro Carvalho Chehab wrote:
>> With all these series applied, it is now possible to use frontend 0
>> for all delivery systems. As the current tools don't support changing
>> the delivery system, the dvb-fe-tool (on my experimental tree[1]) can now
>> be used to change between them:
>>
>> For example, to use DVB-T with the standard scan:
>>
>> $ ./dvb-fe-tool -d DVBT&&  scan /usr/share/dvb/dvb-t/au-Adelaide
>>
>> [1] http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/shortlog/refs/heads/dvb-utils
> 
> I tested that now using nanoStick T2 cxd2820r driver. I got it working somehow, but I suspect there is some bugs at least for DVB-C. But forget those as now.

Well, we need to hardly test the DVB drivers after a 200+ patch series.
Regressions will happen. I've cached a few already, but I'm sure there
are others that are not that trivial.

> As it now registers only one frontend I must switch mode using dvb-fe-tool when I want to use DVB-C. Argh.
> 
> I don't see reason why it was needed to remove old DVB-C frontend1. Why it wasn't possible to leave FE1
> as it was and enhance only functionality of FE0 like it is now? For that strategy we doesn't break old set-ups as now happens.

This were discussed in the past:

	http://www.spinics.net/lists/linux-media/msg35542.html

In fact, I've proposed this strategy as one of the alternatives for MFE
(approach 4):

>>>>> Approach 4) fe0 is a frontend "superset"
>>>>>
>>>>> *adapter0
>>>>> *frontend0 (DVB-S/DVB-S2/DVB-T/DVB-T2/DVB-C/ISDB-T) - aka: FE superset
>>>>> *frontend1 (DVB-S/DVB-S2)
>>>>> *frontend2 (DVB-T/DVB-T2)
>>>>> *frontend3 (DVB-C)
>>>>> *frontend4 (ISDB-T)

The arguments where that it would be confusing and it could be complex
to maintain.

I think that the better is to see what happens with the applications
during this kernel cycle, and then decide what to do. A quick fix for 
the issue at the applications side is very easy: for DVBv5.5 and upper,
just try to force the frontend to change to the new delivery system
via a DVBv5 call. If it accepts, it is a multi frontend devnode.

A better fix is to also implement DTV_ENUM_DELSYS.

Regards,
Mauro
