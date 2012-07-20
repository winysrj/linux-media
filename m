Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:35931 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab2GTJwp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 05:52:45 -0400
Received: from [10.2.0.238] (unknown [10.2.0.238])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by 7of9.schinagl.nl (Postfix) with ESMTPSA id E364424422
	for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 11:53:24 +0200 (CEST)
Message-ID: <50092A6A.6080101@schinagl.nl>
Date: Fri, 20 Jul 2012 11:52:42 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Problems with Asus My Cinema-U3000Hybrid tuner
References: <CAOLE0zPeaRXNJY9yVwVG0n5tsbgYoqw1pQs7_+2fQoA-K0uS3Q@mail.gmail.com> <CAOLE0zMrNpNAa9pvVxXhnN6r_NdAYSHJ7wsGCMACOGCmmgBJRA@mail.gmail.com> <loom.20120719T133924-657@post.gmane.org> <5007EF20.3080800@schinagl.nl> <loom.20120719T205627-29@post.gmane.org> <50086528.1010309@schinagl.nl> <CAOLE0zMWhS7sAg7sDw0-Qv3k+TAVaEDxdQEEmGrpKQLTZrfvVw@mail.gmail.com> <5008FB8B.3020903@schinagl.nl> <CAOLE0zO1158KTV0Yfb1gh-42w+pF2P+vXFuys6fmPMgwjsFOHA@mail.gmail.com>
In-Reply-To: <CAOLE0zO1158KTV0Yfb1gh-42w+pF2P+vXFuys6fmPMgwjsFOHA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20-07-12 11:01, H. Cristiano Alves Machado wrote:
> 2012/7/20 Oliver Schinagl <oliver+list@schinagl.nl>:
>> I did do see those already. Well if you have never seen it properly work in
>> Linux, there may be a few things to try. The easiest is an older version of
>> ubuntu for example. DIB7000 based devices are supported for quite some time.
>> 10.04 was an LTS release, best start with that one to test. The only other
>> thing I could think of, is that maybe your firmware is different. It
>> currently loads 1.20; Maybe try extracting the firmware from your windows
>> driver and try that first.
>>
>> Other then that, I really have no idea :(
> Hi Oliver and thanks for the care you've shown up until now! I really
> appreciate that.
>
> I will try to follow your suggestions.
>
> I will try to install previous version of ubuntu (10.04 LTS first) and
> then the second way, adapt windows'.
I found that on October 13th 2008 Mauro commited support for the Asus My 
Cinema U3000 Hybrid. Mauro is currently on vacation  so your best bet 
would have been him. I also see that Albert Comera and Patrick Boettcher 
signed off on this too, so they should know the details on why it's not 
working.

I've noticed that my PCI DVB-T card works quite some better in kaffeine 
then in VDR. Also me-tv works reasonably well (when not using a CAM). 
Try various applications in your testing enviroment, it may be 
application related.

Unfortunately I can not help you anymore then that.
>
> I have some doubts about extracting windows drivers and applying them here.
>
> How can I go about doing that?
>
> If you (or someone else can give some pointers I will try to follow them)
>
> Besides I will also look (google) around to see how that can be done.
>
> Best regards!

