Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47419 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753240AbZFTVbz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 17:31:55 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Edouard Lafargue <edouard@lafargue.name>
Subject: Re: [PATCH / resubmit] USB interrupt support for radio-si470x FM radio driver
Date: Sat, 20 Jun 2009 23:31:53 +0200
Cc: Alexey Klimov <klimov.linux@gmail.com>,
	linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
References: <268161120906160611q32ac27a8r1574d4a9ffa63829@mail.gmail.com> <208cbae30906161448q16a7e00bx31e6d3b3c35111e5@mail.gmail.com> <268161120906171022j14645f78yf5e075679c30b57c@mail.gmail.com>
In-Reply-To: <268161120906171022j14645f78yf5e075679c30b57c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906202331.54058.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>    Following up on your comments, here is the patch against the
> current mercurial tree, still works fine, and indeed, the stereo/mono
> and strength indicators work better on this newer version. RDS
> reception remains better with my patch :-) Now I just need to bundle
> this with icecast to get mp3 streaming with embedded RDS info, but
> that's outside of the scope of this list.
> 
>    Thanks for all your help, now on to Tobias, I guess!

perfect patch. Thank you Ed. I never figured out how to use interrupt URBs. This really seams to fix the click problem on unbuffered audio forwarding.

The suggestion/question I have is if we want to keep the "users now" log messages in fops_open and fops_release.
After all the testing today this fills up my logs...

I'm going to upload this to mercurial and send Mauro a pull request.

Bye,
Toby
