Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57751 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1G2OwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 10:52:20 -0400
Received: by qyk9 with SMTP id 9so2182223qyk.19
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 07:52:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201106241151.34019@orion.escape-edv.de>
References: <017201cc31ec$de287ce0$9a7976a0$@coexsi.fr>
	<201106241151.34019@orion.escape-edv.de>
Date: Fri, 29 Jul 2011 16:52:19 +0200
Message-ID: <CAP_oYQ5NRpGPd9Kb5YU9Xu-wtsMc+SPTkLjFjX2Q72_rF=4ODg@mail.gmail.com>
Subject: Re: [DVB] Octopus driver status
From: Rune Evjen <rune.evjen@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

I am looking into buying the Digital Devices Cine CT V6 (product link:
http://shop.digital-devices.de/epages/62357162.sf/en_GB/?ObjectPath=/Shops/62357162/Products/091203)

Is this card including multiple dvb-c tuners supported by the ddbridge
(Lattice bridge) driver ?

Is the driver available also in git://linuxtv.org/media_build.git or
do I need to use
http://linuxtv.org/hg/~endriss/media_build_experimental ?

Best regards,

Rune Evjen




2011/6/24 Oliver Endriss <o.endriss@gmx.de>:
> Hi,
>
> On Thursday 23 June 2011 23:31:08 Sébastien RAILLARD wrote:
>> Dear all,
>>
>> I'm looking at the Octopus DVB cards system from Digital Devices for a while
>> as their system seems to be very interesting
>>
>> Here is link with their products:
>> http://shop.digital-devices.de/epages/62357162.sf/en_GB/?ObjectPath=/Shops/6
>> 2357162/Categories
>>
>> The good points I have found:
>>
>> * They support most of the common DVB standards: DVB-C, DVB-T, DVB-S and
>> DVB-S2
>> * They are moderately priced
>> * There is a CAM support with a CI adapter for unscrambling channels
>> * They are using the now de-facto standard PCI-Express bus
>> * The new Octopus system is using a LATTICE PCI-Express bridge that seems to
>> be more future proof than the previous bridge Micronas APB7202A
>> * They seem to be well engineered ("Designed and manufactured in Germany" as
>> they say!)
>>
>> And now the doubts :
>>
>> * The DVB-C/T frontend driver is specific to this system and is very new, so
>> as Devin said one week ago, it's maybe not yet production ready
>> * The way the CAM is supported break all the existing userland DVB
>> applications (gnutv, mumudvb, vlc, etc.)
>> * There isn't so much information about the Digital Devices company and
>> their products roadmap (at least in English)
>>
>> So, my two very simple questions to the developers who worked on the drivers
>> (I think Oliver and Ralph did) and know the product:
>> * How you feel the future about the Octopus driver?
>
> The drivers work fine. I am not aware of any problems.
>
> All Digital Devices cards and tuner variants are supported by the driver
> http://linuxtv.org/hg/~endriss/media_build_experimental
>
> ddbridge (Lattice bridge):
> - Octopus (all variants)
> - cineS2 v6
> - DuoFlex S2 (stv0900 + stv6110 + lnbp21)
> - DuoFlex C/T (Micronas DRXK + NXP TDA18271C2)
>
> ngene bridge:
> - cineS2 (v4,v5), Satix S2 Dual
> - PCIe bridge, mini PCIe bridge
> - DuoFlex S2 (stv0900 + stv6110 + lnbp21)
> - DuoFlex C/T (Micronas DRXK + NXP TDA18271C2)
>
> For a German description, see
> http://www.vdr-portal.de/board16-video-disk-recorder/board85-hdtv-dvb-s2/105803-aktuelle-treiber-für-octopus-ddbridge-cines2-ngene-ddbridge-duoflex-s2-duoflex-ct-sowie-tt-s2-6400
>
> From an operational point of view, the driver is ready for the kernel.
> Unfortunately I did not have the time yet to clean up the coding-style.
> There are thousands of coding-style issues waiting to be fixed...
>
>> * Do you think a compatibility mode (like module parameter) can be added to
>> simulate the way the CAM is handled in the other drivers?
>
> Yes, this could be done:
> ++ The CI could be used with any application.
> -- The CI will be attached to one tuner exclusively.
>
> It is not very hard to implement this.
> Patches are welcome. ;-)
>
> CU
> Oliver
>
> --
> ----------------------------------------------------------------
> VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
> 4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
> Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
> ----------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
