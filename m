Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39854 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbZHLO3Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 10:29:16 -0400
Message-ID: <4A82D2F1.3060800@redhat.com>
Date: Wed, 12 Aug 2009 16:34:25 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ronny Brendel <ronnybrendel@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Decoding pac207
References: <200908081157.51749.ronnybrendel@gmail.com>
In-Reply-To: <200908081157.51749.ronnybrendel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/08/2009 11:57 AM, Ronny Brendel wrote:
> Hello,
> I am currently fiddling some around with capturing pictures from a very cheap
> webcam.
> Unfortunately that webcam uses the rare codec pac207.
>
> Does a decoder (as source) or a description of the codec exist?
> Or can you please give a hint where to search?
>

Well you can use libv4l, and that will do the decoding for you, or you can
lift the decoding code from there:
http://hansdegoede.livejournal.com/3636.html
http://people.atrpms.net/~hdegoede/libv4l-0.6.1-test.tar.gz

Regards,

Hans
