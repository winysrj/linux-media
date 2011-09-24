Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1IXMsm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 08:48:42 -0400
Message-ID: <4E7DD1A5.5080204@infradead.org>
Date: Sat, 24 Sep 2011 09:48:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Lennart Poettering <lpoetter@redhat.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru> <4E2971D4.1060109@infradead.org> <4E29738F.7040605@list.ru> <4E297505.7090307@infradead.org> <4E29E02A.1020402@list.ru> <4E2A23C7.3040209@infradead.org> <4E2A7BF0.8080606@list.ru> <4E2AC742.8020407@infradead.org> <4E2ACAAD.4050602@list.ru> <4E2AE40F.7030108@infradead.org> <4E2C5A35.9030404@list.ru> <4E2C6638.2040707@infrade ad.org> <4E760BCA.6080900@list.ru> <4E7DB798.4060201@infradead.org> <4E7DBB1C.1090407@list.ru> <4E7DC93C.9080101@infradead.org> <4E7DCEC1.6010405@list.ru>
In-Reply-To: <4E7DCEC1.6010405@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-09-2011 09:36, Stas Sergeev escreveu:
> 24.09.2011 16:12, Mauro Carvalho Chehab wrote:
>> The scan audio logic only enables multiple audio standard detection if the userspace
>> application tells it to do.
> No: the _first_ scan is done on the driver init.
> It is a multi-standard one, and a long one, too.
> Do we need it at all? It seems to me the results
> of that scan are not even used, or what am I
> missing?

A first scan at driver's init can be removed, IMO. The thing is that
newer versions of udev will open the device, to do a VIDIOC_QUERYCAP.
Not sure if this will wake up the tvaudio kthread to do a scan.

Regards,
Mauro
