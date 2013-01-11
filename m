Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:33583 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab3AKNhp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:37:45 -0500
Received: by mail-ea0-f182.google.com with SMTP id d1so723236eaa.13
        for <linux-media@vger.kernel.org>; Fri, 11 Jan 2013 05:37:44 -0800 (PST)
Message-ID: <50F015A5.80403@gmail.com>
Date: Fri, 11 Jan 2013 14:37:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Oliver Schinagl <oliver+list@schinagl.nl>,
	Manu Abraham <abraham.manu@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl> <50EAA778.6000307@gmail.com> <50EAC41D.4040403@schinagl.nl> <20130108200149.GB408@linuxtv.org> <50ED3BBB.4040405@schinagl.nl> <20130109084143.5720a1d6@redhat.com> <CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com> <20130109124158.50ddc834@redhat.com> <CAHFNz9+=awiUjve3QPgHtu5Vs2rbGqcLUMzyOojguHnY4wvnOA@mail.gmail.com> <50EF0A4F.1000604@gmail.com> <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com> <50EF1034.7060100@gmail.com> <CAHFNz9KWf=EtvpJ1kDGFPKSvqwd9S51O1=wVYcjNmZE-+_7Emg@mail.gmail.com> <20130110180434.0681a7e1@redhat.com> <CAHFNz9+Jon-YSjkX5gFOTXwX+Vsmi0Rq+X_N61-m2+AEX+8tGg@mail.gmail.com> <50EF29D1.2080102@schinagl.nl> <20130110201134.364d5bc6@redhat.com> <50EF4766.2070100@schinagl.nl> <20130111103937.2cd0d5c8@redhat.com>
In-Reply-To: <20130111103937.2cd0d5c8@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/11/2013 01:39 PM, Mauro Carvalho Chehab wrote:
> tgz:
> 	git archive --format tgz HEAD >dtv-scan-files-`date +"%Y%m%d.%H:%M"`.tar.gz

Better to use the top commit date:
git log -n1 --date=short --pretty=format:%ad

You won't generate a snapshot every day with the same contents then.

or %ad-g%p if you want also a short commit id in there.

-- 
js
