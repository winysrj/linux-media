Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <marcmltd@marcm.co.uk>) id 1OvciL-0001sq-QL
	for linux-dvb@linuxtv.org; Tue, 14 Sep 2010 23:06:54 +0200
Received: from 87-194-101-244.bethere.co.uk ([87.194.101.244] helo=marcm.co.uk)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OvciL-0005d9-Ax; Tue, 14 Sep 2010 23:06:53 +0200
References: <521CE7BF573A436C94F0D9CDAEAF3524@MARCM.local>
From: "Marc Murphy" <marcmltd@marcm.co.uk>
In-Reply-To: <521CE7BF573A436C94F0D9CDAEAF3524@MARCM.local>
Message-ID: <E0626F02-B5EC-439B-8673-EF870AC0B5BE@marcm.co.uk>
Date: Tue, 14 Sep 2010 22:06:56 +0100
To: <linux-media@vger.kernel.org>
MIME-Version: 1.0 (iPhone Mail 8A293)
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DSM-CC question
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Have a look at libdsmcc. It will write by default to /tmp/cache I have modified my test software to notify of a new file or updated file version. 

Hope this helps

Marc

Sent from my iPhone

On 14 Sep 2010, at 21:31, "Suchita Gupta" <suchitagupta@yahoo.com> wrote:

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
> Also, as far as I understand it, I can't start writing to the local filesystem 
> until I have acquired the whole carousel.
> 
> Can, anyone please provide me some guidance.
> 
> Thanks in Advance,
> rs
> 
> 
> 
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
