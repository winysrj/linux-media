Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39731 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1J3V0C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 17:26:02 -0400
Date: Sun, 30 Oct 2011 22:25:50 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [RESEND PATCH 1/14] staging/media/as102: initial import from
 Abilis
Message-ID: <20111030222550.618a5f17@stein>
In-Reply-To: <4EADBBB7.7070802@poczta.onet.pl>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
	<20111018111134.8482d1f8.chmooreck@poczta.onet.pl>
	<20111018214634.544344cc@darkstar>
	<4EADBBB7.7070802@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 30 Piotr Chmura wrote:
> > + * Note:
> > + * - in AS102 SNR=MER
> > + *   - the SNR will be returned in linear terms, i.e. not in dB
> > + *   - the accuracy equals Â±2dB for a SNR range from 4dB to 30dB
> > + *   - the accuracy is>2dB for SNR values outside this range
> > + */
> 
> I found another issue here.
> In this comment "±" is from upper ASCII (0xF1). Should I change it into 
> sth. like "+/-" in this patch (1/14) or leave it and just resend without 
> "Â" (wasn't there in original patch, don't know where it came from) ?

Special characters can be used in comments, provided that they are UTF-8
encoded.  In case of names of persons or companies, it is very much
desirable to preserve special characters.  In case like this one on the
other hand, sticking with ASCII (the 7 bit character table) might not be
such a bad idea to keep things simple.  But since you are passing on a
patch from somebody else, the right thing to do is IMO to keep the special
characters that the author chose and only make sure that the file (and
the patch mailing) are UTF-8 encoded.
-- 
Stefan Richter
-=====-==-== =-=- ====-
http://arcgraph.de/sr/
