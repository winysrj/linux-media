Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:58044 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752318AbcIGJwJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 05:52:09 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 2/2] v4l-utils: fixed dvbv5 vdr format
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160906124723.6783fd39@vento.lan>
Date: Wed, 7 Sep 2016 11:51:26 +0200
Cc: Chris Mayo <aklhfex@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7C627C3A-DF3F-4E50-9876-7130D9221D96@darmarit.de>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de> <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de> <20160824114927.3c6ab0d6@vento.lan> <20160824115241.7e2c90ca@vento.lan> <28A9DFEA-1E94-4EE0-A2BB-B22D029683B9@darmarit.de> <20160905102511.6de3dbe4@vento.lan> <eaa7b609-2c27-9943-5197-d9bec71b2db7@gmail.com> <20160906064108.5bd84045@vento.lan> <CAA7C2qj5ap3PoK2uenF+kqpCrqjO9znR4y5Y7h2UoaENDcT8XA@mail.gmail.com> <20160906124723.6783fd39@vento.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        VDR User <user.vdr@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 06.09.2016 um 17:47 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Tue, 6 Sep 2016 08:16:22 -0700
> VDR User <user.vdr@gmail.com> escreveu:
> 
>> I can tell you that people do still use VDR-1.6.0-3. It would be
>> unwise (and unnecessary) to break backwards compatible, which would be
>> grounds for NACK if you ask me. Knowingly causing breakage has always
>> been an unpopular thing in the VDR community,

not only in the VDR community

>> and this sounds like
>> it's going beyond fixing a small issue

It is broken (see below). Have you ever used dvbv5 tools with vdr format
output or did you know a "VDR user" who is using dvbv5-scan and not wscan?

>> to fixing it til it breaks.
> 
> Well, the libdvbv5 VDR output support was written aiming VDR version 2.1.6.
> I've no idea if it works with VDR 1.6.0. Don't remember if I tested support
> for such version when I wrote the code.
> 
> Also, as it seems that VDR 1.6.0 was released in 2008, it probably won't
> support DVB-T2 (with was added in 2011) and may not support DVB-S2
> (added in 2008, but support for DTV_STREAM_ID seems to be added only
> in 2012).

For me it is completely unclear, what was added when (see below).

> So, at least for DVB-T2/DVB-S2, people likely need some version newer
> than VDR 1.6.0 for full support. If so, the changes proposed by Markus
> and Chris won't be disruptive for 1.6, as they seem to be touching only
> on DVB-T2 and DVB-S2 support, right?

Not only DVB-T2 and DVB-S2, we also fix 

* the leading ":" 
* the symbol SRate of DVB-T DVB-T2,
* if given, the orbital position of DVB-S DVB-S2 is inserted and
* there is no field at position 4 / in between "Source" and "SRate" which
  might have a value. I suppose the '(null):' is the result of pointing
  to *nothing*.

E.g.: Chris fix DVB-T: 
old --> BBC TWO:498000:S0B8C23D12I999M64T8G32Y0:T:27500:201:202,206:0:0:4287:0:0:0:
new --> BBC TWO:498000:B8C23D12G32I999M64S0T8Y0:T:0:201:202,206:0:0:4287:0:0:0

E.g.: Markus fix DVB-S2:
old --> Das Erste HD:11494:S1HC23I0M5N1O35:S:(null):22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0:
new --> Das Erste HD:11494:S1HC23I0M5N1O35:S:22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0


Since these bugs are from the beginning and no one has rejected, 
I suppose, that these VDR 1.6.0 users are using wscan and not the
dvbv5 tools. IMHO the VDR format has never been worked,
so we can't break backwards compatible ;) and since there is wscan
widely used by old vdr hats, we do not need to care pre-DVB-[T|S]-2
formats.

As I said, it might be more helpful to place vdr in a public
repository and to document channel's format well. It is always a
hell for me to dig into the vdr sources without a version 
context and an ambiguous documentation ...

Different formats (compare):
* http://www.vdr-wiki.de/wiki/index.php/Channels.conf#Unterschiede
* https://www.linuxtv.org/vdrwiki/index.php/Syntax_of_channels.conf#Differences

Obsolete wscan
* http://www.vdr-wiki.de/wiki/index.php/Channels.conf_DVBS-S19.2E_Astra
e.g: 
Das Erste HD;ARD:11361:hC23M5O35S1:S19.2E:22000:6010:6020=ger,6021=ger;6022:6030:0:11100:1:1011:0

Dead channel editors:
* http://www.vdr-wiki.de/wiki/index.php/Channeleditoren

VDR wiki recommends wscan
* http://www.vdr-wiki.de/wiki/index.php/W_scan

I think, there is much room left to support developers and users
outside the vdr community ;) 

Would you like to test these patches from Chris and mine / Thanks
that will be very helpful.


-- M --




> 
> Please correct me if I'm wrong.
> 
> Thanks,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

