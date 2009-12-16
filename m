Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([206.112.117.35]:36088 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S934607AbZLPHVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 02:21:49 -0500
Subject: Re: USB MAssage Storage drivers
From: Philby John <pjohn@in.mvista.com>
To: Gopala Gottumukkala <ggottumu@Cernium.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org
In-Reply-To: <03A2FA9E0D3DC841992E682BF5287718016D39D9@lipwig.Cernium.local>
References: <1259596313-16712-1-git-send-email-santiago.nunez@ridgerun.com>
	 <200912152149.33065.hverkuil@xs4all.nl>
	 <03A2FA9E0D3DC841992E682BF5287718016D39D9@lipwig.Cernium.local>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 12:51:45 +0530
Message-Id: <1260948105.4253.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-12-15 at 18:46 -0500, Gopala Gottumukkala wrote:
> My target is not recognizing the USB massage storage. I am working the
> 2.6.32 Davinci kernel
> 
> Any suggestion and ideas.

ahah, this information isn't enough. Your Vendor/Product ID for this
device is compared in a lookup a table. If no match is found, your
device probably won't be detected as mass storage. You could check in
the unusual_devs.h to see if your device is included there, if your
device is relatively new you could submit a Vendor/Product ID to the USB
dev list for inclusion.


Regards,
Philby






