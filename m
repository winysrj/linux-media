Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:44926 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbZICK4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 06:56:37 -0400
Message-ID: <4A9FA0E4.2080603@onelan.com>
Date: Thu, 03 Sep 2009 11:56:36 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working well
 together
References: <4A9E9E08.7090104@onelan.com> <4A9EAF07.3040303@hhs.nl> <4A9F89AD.7030106@onelan.com> <4A9F9006.6020203@hhs.nl> <4A9F98BA.3010001@onelan.com> <4A9F9C5F.9000007@onelan.com>
In-Reply-To: <4A9F9C5F.9000007@onelan.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simon Farnsworth wrote:
> I appear to lose colour after a few seconds of capture, which I shall chase
> further.

And resolved - I was off-frequency by 2MHz, which leaves me surprised that
I got picture. Only thing left for me to sort out is audio support.

-- 
Thanks for your help,

Simon Farnsworth

