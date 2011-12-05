Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:50739 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932076Ab1LEMbx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Dec 2011 07:31:53 -0500
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1RXXi4-0004rl-Eb
	for linux-media@vger.kernel.org; Mon, 05 Dec 2011 04:31:52 -0800
Message-ID: <4EDCB9B8.4030104@seiner.com>
Date: Mon, 05 Dec 2011 04:31:52 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx231xx kernel oops
References: <4EDC25F1.4000909@seiner.com> <1323058527.12343.3.camel@palomino.walls.org> <4EDC4C84.2030904@seiner.com> <4EDC4E9B.40301@seiner.com> <4EDCB6D1.1060508@seiner.com>
In-Reply-To: <4EDCB6D1.1060508@seiner.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yan Seiner wrote:
> I'm still seeing a kernel oops on use.
One more minor point:

Before the kernel oops, I have /dev/video0.  After the oops, I have 
/dev/video0 and /dev/video1 - probably related to the ehci crash.

-- 
Few people are capable of expressing with equanimity opinions which differ from the prejudices of their social environment. Most people are even incapable of forming such opinions.
    Albert Einstein

