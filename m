Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57086 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2KDWX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2012 17:23:28 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Andrey Gusakov <dron0gus@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
Date: Sun, 04 Nov 2012 23:23:25 +0100
Message-ID: <2110908.qaFg5OjAC4@flatron>
In-Reply-To: <5096E8D7.4070304@gmail.com>
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com> <CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com> <5096E8D7.4070304@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

On Sunday 04 of November 2012 23:14:47 Sylwester Nawrocki wrote:
> >> Are you using this version of patches:
> >> http://git.linuxtv.org/snawrocki/media.git/shortlog/refs/heads/s3c-cam
> >> if ?> 
> > I'm using patches from
> > https://github.com/snawrocki/linux/commits/s3c-camif-v3.5 wich was in
> > your mail to samsung maillist.
> 
> I suggest you to update to the s3c-camif branch as above, it includes
> some bug fixes. Sorry, I don't have exact patch for your issue handy
> right now.

Yes, you should definitely try the branch pointed by Sylwester, because the 
one you originally tested does not contain my fixes for S3C6410.

Best regards,
Tomasz Figa

