Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63234 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab1JMSbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 14:31:01 -0400
Received: by bkbzt4 with SMTP id zt4so1804948bkb.19
        for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 11:31:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E972A8F.2020004@lockie.ca>
References: <4E972A8F.2020004@lockie.ca>
Date: Thu, 13 Oct 2011 14:30:59 -0400
Message-ID: <CAGoCfiygsxpA_qpoJ=BJ2YorqRPxg8ooMhvTMqscoxH1m+rh6A@mail.gmail.com>
Subject: Re: help with azap
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: James <bjlockie@lockie.ca>
Cc: linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 13, 2011 at 2:14 PM, James <bjlockie@lockie.ca> wrote:
> $ more channels.conf
> CIII-HD:85000000:8VSB:49:52+53:1
> OTTAWA CBOFT-DT:189000000:8VSB:49:53+52:3
> CJOH:213000000:8VSB:49:51+52:1
> TVO    :533000000:8VSB:49:52+53:1
> OTTAWA  CBOT-DT:539000000:8VSB:49:52+53:3
> Télé-Québec_HD:569000000:8VSB:49:52+53:3
> CHOT:629000000:8VSB:49:52:3
>
> $ azap -c channels.conf "CJOH"
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> ERROR: error while parsing Audio PID (not a number)
>
> $ tzap -c channels.conf "CJOH"
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file 'channels.conf'
> ERROR: error while parsing inversion (syntax error)
>
> Why does tzap show what file it is reading the channel list from but azap
> doesn't?

If I recall, tzap and azap are actually from different codebases
(although I believe one was originally derived from the other).  That
is why the output is a little inconsistent.

That said, you should not be using tzap for ATSC/ClearQAM.  tzap is for DVB-T.

> What does "ERROR: error while parsing Audio PID (not a number)" mean?

I don't know where your channels.conf came from, but it appears to be
malformed.  You cannot have "52+53" as the audio PID.  If you just
want to get up and running, remove the "+53" part.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
