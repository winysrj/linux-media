Return-path: <mchehab@pedra>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:53515 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab0IQJAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 05:00:49 -0400
Message-ID: <4C932E3F.4040208@linuxtv.org>
Date: Fri, 17 Sep 2010 11:00:47 +0200
From: Marek Pikarski <mass@linuxtv.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DSM-CC question
References: <618132.61670.qm@web55408.mail.re4.yahoo.com>
In-Reply-To: <618132.61670.qm@web55408.mail.re4.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Suchita Gupta wrote:
> Hi,
>
> First of all, I am new to this list, so I am not sire if this is right place for 
> this question.
> If not, please forgive me and point me to right list.
>
> I am writing a DSMCC decoding implementation to persist it to local filesystem.
> I am unable to understand few thiings related to "srg"
>
> I know, it represents the top level directory. But how do I get the name of this 
> directory?
> I can extract the names of subdirs and files using name components but where is 
> the name of top level directory?
>   

The SRG component defines the carousel's root directory "/" which you
are going to
mount somewhere to an absolute path on your local filesystem.

> Also, as far as I understand it, I can't start writing to the local filesystem 
> until I have acquired the whole carousel.
>   

The referenced ObjectKey's data gets delivered with modules, at the
latest from
this point you can store the FIL objects to disk, as these are then
really available.
The directory structure can be created immediately, of course.

> Can, anyone please provide me some guidance.
>   
Don't hesitate to ask more detailed questions, thats the right place here!

Regards, Marek

