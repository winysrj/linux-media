Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64331 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab1HILvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 07:51:21 -0400
Received: by fxh19 with SMTP id 19so6414961fxh.19
        for <linux-media@vger.kernel.org>; Tue, 09 Aug 2011 04:51:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ipq6suv4.fsf@nemi.mork.no>
References: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com>
	<1312887439.2249.38.camel@ares>
	<87ipq6suv4.fsf@nemi.mork.no>
Date: Tue, 9 Aug 2011 13:51:20 +0200
Message-ID: <CAC3jWvLK96m3Epo7ihnztq1VERRhYAiDPGsEz5CBM_xgs=A-7w@mail.gmail.com>
Subject: Re: Anyone tested the DVB-T2 dual tuner TBS6280?
From: Harald Gustafsson <hgu1972@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks all for your quick answers.

On Tue, Aug 9, 2011 at 1:10 PM, Bjørn Mork <bjorn@mork.no> wrote:
> There's a binary-only tbs62x0fe_driver for x86_{32,64} in the archive,
> so it _might_ work.  But I don't think anyone here will recommend
> something like that...

Yes, this is what I was afraid of. That it was binary drivers, and I
agree that this usually only leads to problems when integrating it
with kernels that was not thought of by the developers.

Since I unfortunately don't have time to reverse engineer this binary
driver, I think I wait for another dual tuner DVB-T2 card shows up.

Thanks,
 Harald
