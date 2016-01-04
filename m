Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55624 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbcADTLD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 14:11:03 -0500
Date: Mon, 4 Jan 2016 17:10:55 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Mike Martin <mike@redtux.org.uk>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: Questions about dvbv5-scan (missing fields)
Message-ID: <20160104171055.74c6f7e0@recife.lan>
In-Reply-To: <CAOwYNKZU-eb+hCzMWiBf+TNoCfTzepLn1aMiivaPNZV0qxOWUA@mail.gmail.com>
References: <CAOwYNKZU-eb+hCzMWiBf+TNoCfTzepLn1aMiivaPNZV0qxOWUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 31 Dec 2015 13:45:43 +0000
Mike Martin <mike@redtux.org.uk> escreveu:

> Hi
> I hope this is the right list to ask.
> 
> I am looking at using dvbv5 for one of my projects. However there are
> some fields that I cant seem to get, in particular
> 
> tsid
> pmt
> service_type (TV?Radio etc)
> net
> netid
> example output in VDR format
> 
> CBS Drama:538000:S0B8C34D12I1M64T8G32Y0:T:27500:0:0:0:0:14640:0:0:0:
> Showcase TV:538000:S0B8C34D12I1M64T8G32Y0:T:27500:0:0:0:0:15296:0:0:0:
> Box Nation:538000:S0B8C34D12I1M64T8G32Y0:T:27500:0:0:0:0:14416:0:0:0:
> Horror
> Channel:538000:S0B8C34D12I1M64T8G32Y0:T:27500:6129:6130,6131:0:0:14480:0:0:0:
> 365 Travel:538000:S0B8C34D12I1M64T8G32Y0:T:27500:0:0:0:0:14784:0:0:0:
> Television X:538000:S0B8C34D12I1M64T8G32Y0:T:27500:0:0:0:0:15232:0:0:0: 5
> USA:538000:S0B8C34D12I1M64T8G32Y0:T:27500:6689:6690,6691:0:0:12992:0:0:0:
> 5*:538000:S0B8C34D12I1M64T8G32Y0:T:27500:6673:6674,6675:0:0:12928:0:0:0:
> QUEST:538000:S0B8C34D12I1M64T8G32Y0:T:27500:6929:6930,6931:0:0:14498:0:0:0:
> 
> A can be seen there is loads of zeros where entries should be

Well, the tool provides DVR compatible file format, but it doesn't
actually get the above fields (well, some are actually retrieved but
not stored).

Last time I checked, this is not a problem, since DVR update those
field when it runs.

It wouldn't be hard to update the tool to also retrieve/store those
fields, but you'll need to write the patch. If you do so, feel free to
submit it to linux-media.

Btw, I'm starting vacations today, so you won't hear from me about this
subject for a while.

Regards,
Mauro


> 
> thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
