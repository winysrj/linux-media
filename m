Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:53464 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab0A0RSF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 12:18:05 -0500
Received: by ywh36 with SMTP id 36so105966ywh.15
        for <linux-media@vger.kernel.org>; Wed, 27 Jan 2010 09:18:04 -0800 (PST)
Date: Wed, 27 Jan 2010 15:17:53 -0200
From: Nicolau Werneck <nwerneck@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Setting up white balance on a t613 camera
Message-ID: <20100127171753.GA10865@pathfinder.pcs.usp.br>
References: <20100126170053.GA5995@pathfinder.pcs.usp.br> <20100126193726.00bcbc00@tele> <20100127163709.GA10435@pathfinder.pcs.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127163709.GA10435@pathfinder.pcs.usp.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Answering my own question, and also a question in the t613 source
code...

Yes, the need for the "reg_w(gspca_dev, 0x2087);", 0x2088 and 0x2089
commands are definitely tied to the white balance. These three set up
the default values I found out. And (X << 8 + 87) sets up the red
channel parameter in general, and 88 is for green and 89 for blue.

That means I can already just play with them and see what happens. My
personal problem is that I bought this new lens, and the image is way
too bright, and changing that seems to help. But I would like to offer
these as parameters the user can set using v4l2 programs. I can try
making that big change myself, but help from a more experienced
developer would be certainly much appreciated!...

   ++nicolau




On Wed, Jan 27, 2010 at 02:37:09PM -0200, Nicolau Werneck wrote:
> Hello again, people. I believe I have found in my log the commands
> that are setting up that white balance parameters. I am pasting an
> excerpt of the log at the end. (I changed the subject now that is
> seems this is actually the way I should follow)
> 
> It looks to me that in that SetupPacket vector the "88" encodes what
> channel to set. 87 for red, 88 for blue and 89 for green. The
> following value is the level, which is default to 0x20. 
> 
> The question now is how do I offer to set up that parameter in the
> driver? What function can I use to transmits a vector that way, so I
> can make a hacky test?
> 
> In other words: would it be possible or me to just cut and paste some
> code in the driver to implement that? Or will I be finally forced to
> actually learn what I am doing? :)
> 
> regards,
> 
>    ++nicolau

-- 
Nicolau Werneck <nwerneck@gmail.com>          1AAB 4050 1999 BDFF 4862
http://www.lti.pcs.usp.br/~nwerneck           4A33 D2B5 648B 4789 0327
Linux user #460716

