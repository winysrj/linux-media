Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:48455 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbZJBNH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 09:07:26 -0400
Received: by bwz6 with SMTP id 6so964098bwz.37
        for <linux-media@vger.kernel.org>; Fri, 02 Oct 2009 06:07:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091002091255.GA29221@systol-ng.god.lan>
References: <20090922210915.GD8661@systol-ng.god.lan>
	 <37219a840909241155h1b809877mf7ae1807e34a2f87@mail.gmail.com>
	 <20091002091255.GA29221@systol-ng.god.lan>
Date: Fri, 2 Oct 2009 09:07:29 -0400
Message-ID: <37219a840910020607g5a0560b3r49ff48dc0c85327d@mail.gmail.com>
Subject: Re: [PATCH 4/4] Zolid Hybrid PCI card add AGC control
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk.Vergonet@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 2, 2009 at 5:12 AM,  <spam@systol-ng.god.lan> wrote:
> On Thu, Sep 24, 2009 at 02:55:42PM -0400, Michael Krufky wrote:
>> On Tue, Sep 22, 2009 at 5:09 PM,  <spam@systol-ng.god.lan> wrote:
>> >
>> > Switches IF AGC control via GPIO 21 of the saa7134. Improves DTV reception and
>> > FM radio reception.
>> >
>> > Signed-off-by: Henk.Vergonet@gmail.com
>>
>> Reviewed-by: Michael Krufky <mkrufky@kernellabs.com>
>>
>> Henk,
>>
>> This is *very* interesting...  Have you taken a scope to the board to
>> measure AGC interference?   This seems to be *very* similar to
>> Hauppauge's design for the HVR1120 and HVR1150 boards, which are
>> actually *not* based on any reference design.
>>
>> I have no problems with this patch, but I would be interested to hear
>> that you can prove it is actually needed by using a scope.  If you
>> don't have a scope, I understand....  but this certainly peaks my
>> interest.
>>
>> Do you have schematics of that board?
>>
>> Regards,
>>
>> Mike Krufky
>>
>
> One note: I have tested the tda18271 signedness fixes in the debug
> repository. This is a big improvement in reception.
>
> Based on the latest testing with all the fixes I would say that
> switching the AGC line via gpio is not needed and leaving it at 0 gives
> the best results.
> (This is purely based on SNR and BER readings from tzap)
>
> So I would recomend: leaving config at zero.
>
>  static struct tda18271_config zolid_tda18271_config = {
>        .std_map = &zolid_tda18271_std_map,
>        .gate    = TDA18271_GATE_ANALOG,
> -       .config  = 3,
> +//     .config  = 3,
>        .output_opt = TDA18271_OUTPUT_LT_OFF,
>  };
>

I removed the patch from my tree awaiting merge, "saa7134: add AGC
control for Zolid Hybrid PCI card".

It wasn't as simple as changing the 3 to a 0, since the function,
"saa7134_tda18271_zolid_toggle_agc" becomes a no-op.

Also, you've been sending the sign-off's in the wrong format in your
previous submissions.

Please send in the "FM reception via RF_IN" as a separate patch, and
include your sign-off using the actual format:

Signed-off-by: Your Name <email@addre.ss>

Regards,

Mike
