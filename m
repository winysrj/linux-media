Return-path: <linux-media-owner@vger.kernel.org>
Received: from 78.218.95.91.static.ter-s.siw.siwnet.net ([91.95.218.78]:42210
	"EHLO alefors.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZKUIvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 03:51:04 -0500
Received: from [10.0.0.11] ([10.0.0.11]:46325)
	by alefors.se with [XMail 1.26 ESMTP Server]
	id <S62E> for <linux-media@vger.kernel.org> from <magnus@alefors.se>;
	Sat, 21 Nov 2009 09:51:06 +0100
Message-ID: <4B07A9F6.8040205@alefors.se>
Date: Sat, 21 Nov 2009 09:51:02 +0100
From: =?UTF-8?B?TWFnbnVzIEjDtnJsaW4=?= <magnus@alefors.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: SV: [linux-dvb] NOVA-TD exeriences?
References: <4AEF5FE5.2000607@stud.uni-hannover.de> <4AF162BC.4010700@stud.uni-hannover.de> <4B0694F7.7070604@stud.uni-hannover.de> <4B06A22D.4090404@stud.uni-hannover.de> <4B072D3F.8060807@stud.uni-hannover.de>
In-Reply-To: <4B072D3F.8060807@stud.uni-hannover.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Soeren Moch wrote:
> OK, my nova-td device id is 2040:9580, for 2040:5200 the attached 
> extended
> patch version may help. (I have no access to such device.)
> Please test.
>
> Soeren
>

Well, it did help thank you very much! Now I finally have four DVB-T and 
four DVB-S2 adapters that can take any transponder I have access to 
without problems. I haven't looked into your patches yet but I hope the 
problems get solved in the main linuxtv tree soon, one way or the other.
Thanks again,
/Magnus H

