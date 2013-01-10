Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:53738 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3AJTDF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 14:03:05 -0500
Received: by mail-ea0-f181.google.com with SMTP id k14so366081eaa.26
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 11:03:04 -0800 (PST)
Message-ID: <50EF1065.40007@gmail.com>
Date: Thu, 10 Jan 2013 20:03:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl> <50EAA778.6000307@gmail.com> <50EAC41D.4040403@schinagl.nl> <20130108200149.GB408@linuxtv.org> <50ED3BBB.4040405@schinagl.nl> <20130109084143.5720a1d6@redhat.com> <CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com> <20130109124158.50ddc834@redhat.com> <CAHFNz9+=awiUjve3QPgHtu5Vs2rbGqcLUMzyOojguHnY4wvnOA@mail.gmail.com> <50EF0A4F.1000604@gmail.com> <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com> <CAOcJUbwya++5nW_MKvGOGbeXCbxFgahu_AWEGBb6TLNx0Pz53A@mail.gmail.com>
In-Reply-To: <CAOcJUbwya++5nW_MKvGOGbeXCbxFgahu_AWEGBb6TLNx0Pz53A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/2013 07:56 PM, Michael Krufky wrote:
> I see great value in separating the history of the data files from the
> code files.  If you really think this is such a terrible task for a
> developer to have to pull from a second repository to fetch these data
> files, then I find no reason why we couldn't script it such that
> building the dvb-apps package would trigger the pull from the
> additional repository.

(Or use submodules.)

-- 
js
