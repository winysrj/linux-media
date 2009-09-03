Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp126.rog.mail.re2.yahoo.com ([206.190.53.31]:28567 "HELO
	smtp126.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754574AbZICGee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 02:34:34 -0400
Message-ID: <4A9F61E2.5010302@rogers.com>
Date: Thu, 03 Sep 2009 02:27:46 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Peter Brouwer <pb.maillists@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Should I see a videoN and audioN in /dev/dvb/adapterN??
References: <4A9E5B88.50001@googlemail.com>
In-Reply-To: <4A9E5B88.50001@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Peter Brouwer wrote:
> I am using a S460 Tevii ( Cx88) and a nova T 500 card.
> I see three adapter directories ( T 500 is dual tuner).
> Each has demux0 frontend0 net0 and dvr0
>
> Should I not see a video0 and audio0 in each of them too?
> I see one /dev/video0 and one /dev/vbi0 that seems to belong to the
> S460 card
>

See here: http://www.linuxtv.org/wiki/index.php/Device_nodes
