Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63167 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab1HTMgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 08:36:11 -0400
Received: by ewy4 with SMTP id 4so1405792ewy.19
        for <linux-media@vger.kernel.org>; Sat, 20 Aug 2011 05:36:10 -0700 (PDT)
Message-ID: <4E4FAA37.20703@gmail.com>
Date: Sat, 20 Aug 2011 14:36:07 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 1/2] EM28xx - fix race on disconnect
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com> <4E4D8DFD.5060800@yahoo.com> <4E4DFA65.4090508@redhat.com> <4E4F9DA4.90701@yahoo.com>
In-Reply-To: <4E4F9DA4.90701@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On 08/20/2011 01:42 PM, Chris Rankin wrote:
> *Sigh* I overlooked two patches in the original numbering...

How about using git format-patch and git send-email ?
http://www.kernel.org/pub/software/scm/git/docs/git-send-email.html

It's easier to review when patches are inlined rather than sent
as an attachment.

git format-patch will make you a nice series of patches. For instance,
when you have 3 of your patches applied on top of some branch and it's
checked out, to generate the patches the simple command:

$ git format-patch -3 --cover-letter

will do. Then you just need to pass the files to 'git send-email'.

Also, the patch description should be wrapped around 75 characters.
So there is no need for text wrapping with 'git log', etc.

Unfortunately git send-email won't work with free e-email accounts
on yahoo.com. The SMTP server throws an error like:
"Access denied : Free users cannot access this server."
Gmail works for me.

--
Regards,
Sylwester
