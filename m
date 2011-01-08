Return-path: <mchehab@pedra>
Received: from cain.gsoft.com.au ([203.31.81.10]:60614 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1AHM4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 07:56:50 -0500
Subject: Re: Unable to build media_build (mk II)
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: "Daniel O'Connor" <darius@dons.net.au>
In-Reply-To: <201101081344.54075.hverkuil@xs4all.nl>
Date: Sat, 8 Jan 2011 23:26:27 +1030
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3D9DDC44-3862-4106-AC12-488A49CA95A8@dons.net.au>
References: <155DD6D6-0766-4501-9B03-D5945460B040@dons.net.au> <201101081344.54075.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


On 08/01/2011, at 23:14, Hans Verkuil wrote:
>> Looking at some other consumers of that function it would appear the last argument (NULL in this case) is superfluous, however the file appears to be replaced each time I run build.sh so I can't update it.
> 
> Only run build.sh once. After that you can modify files and just run 'make'.
> 
> build.sh will indeed overwrite the drivers every time you run it so you should
> that only if you want to get the latest source code.

Ahh, I see.

Any chance the README could be modified to say something about that?

Currently it doesn't mention build.sh at all - I had to google to find anything of use.

Perhaps also rename build.sh to setup.sh.

Thanks :)

--
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C






