Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58609 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1FVQU5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 12:20:57 -0400
Received: by iwn6 with SMTP id 6so821093iwn.19
        for <linux-media@vger.kernel.org>; Wed, 22 Jun 2011 09:20:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>
	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>
	<BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>
	<BANLkTimg0X5H5T8CsSR5Tr0CZbCZKiDEEA@mail.gmail.com>
	<4DFFB1DA.5000602@redhat.com>
	<BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com>
Date: Wed, 22 Jun 2011 12:20:56 -0400
Message-ID: <BANLkTikiZosMHMSEZzKKGD-A2aR4UV3_Mg@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: Steven Toth <stoth@kernellabs.com>
To: HoP <jpetrous@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	=?ISO-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>,
	=?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>> This is not a political issue. It is a licensing issue. If you want to use
>> someone's else code, you need to accept the licensing terms that the developers
>> are giving you, by either paying the price for the code usage (on closed source
>> licensing models), or by accepting the license when using an open-sourced code.

Mauro,

My comments for your review:

I've spoken on this topic many times, it's bad news for the LinuxTV
eco-system and it will eventually lead to binary only drivers that
ultimately diminishes all of the good work that me any my fellow
developers have poured into Linux over the last 5-10 years.

I repeat my message from 2 years ago when the subject was raised: and
this is (paraphrase) "I can say with great certainty that if we allow
API's that permit closed source drivers then silicon vendors and board
manufacturers will take advantage of that, they will only delivery (at
best) closed source drivers".

If closed source drivers is what the community wants then this is a
way to achieve this.

I don't want to see user-space drivers happen through LinuxDVB or V4L2 API's.

I politely and respectfully nack this idea.

Best,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
