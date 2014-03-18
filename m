Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:47258 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaCRJJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 05:09:08 -0400
Received: by mail-ve0-f182.google.com with SMTP id jw12so6576936veb.41
        for <linux-media@vger.kernel.org>; Tue, 18 Mar 2014 02:09:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395099887.87256.YahooMailNeo@web120305.mail.ne1.yahoo.com>
References: <1395099887.87256.YahooMailNeo@web120305.mail.ne1.yahoo.com>
From: Simon Liddicott <simon@liddicott.com>
Date: Tue, 18 Mar 2014 09:08:47 +0000
Message-ID: <CALuNSF6zW3GP+6JGk1c=1MGspcyE4-6HC=7x_ZV0Medf=JcWPg@mail.gmail.com>
Subject: Re: Updated DVB-T tables - where to send them?
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17 March 2014 23:44, Chris Rankin <rankincj@yahoo.com> wrote:
>
>
> Hi,
>
> The DVB-T initial tuning information for Crystal Palace in the UK is completely obsolete - despite my two attempts to submit an updated version over the YEARS. Where is the best place to send this information, please?
>
> Thanks,
> Chris
>

I submitted updates for the whole of the UK in September.

Check Crystal Palace here:
<http://git.linuxtv.org/dtv-scan-tables.git/blob_plain/HEAD:/dvb-t/uk-CrystalPalace>

You will probably find your distro hasn't updated.

I did a pull request into this github repo
<https://github.com/oliv3r/dtv-scan-tables>

Si.
