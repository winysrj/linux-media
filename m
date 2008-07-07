Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail4.riotinto.com ([210.8.150.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Tom.George@riotinto.com>) id 1KFjdf-0005Fq-S1
	for linux-dvb@linuxtv.org; Mon, 07 Jul 2008 07:51:55 +0200
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Mon, 7 Jul 2008 13:51:10 +0800
Message-ID: <C74607610AB6D64794BA3820A9567DA705AAD625@sbscpex06.corp.riotinto.org>
In-Reply-To: <1215159877.7545.3.camel@acropora>
References: <C74607610AB6D64794BA3820A9567DA705A6C81A@sbscpex06.corp.riotinto.org><486D9AE8.1030205@internode.on.net>
	<1215159877.7545.3.camel@acropora>
From: "George, Tom \(RTIO\)" <Tom.George@riotinto.com>
To: "Nicolas Will" <nico@youplala.net>,
	<linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] dvb_usb_dib0700 tuning problems?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Thanks Nic,

Moving away from the pre-built binaries that come with ubuntu and using
the latest tree from linuxtv has solved my problems.

I have noticed however that reception is definitely poorer when running
using the 2.6.24-19-generic kernel than with the 2.6.24-16-generic
kernel.... Pretty weird! (I can pick up channel 10 with the -16 and not
with the -19)

Thanks,

Tom

-----Original Message-----
From: linux-dvb-bounces@linuxtv.org
[mailto:linux-dvb-bounces@linuxtv.org] On Behalf Of Nicolas Will
Sent: Friday, 4 July 2008 4:25 PM
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb_usb_dib0700 tuning problems?

On Fri, 2008-07-04 at 13:07 +0930, Ian W Roberts wrote:
> Just maybe you'll need to re-compile drivers (although maybe not given

> it's working for one channel). I had to on gutsy and heron.

I would still recommend to use a recent tree for such boards, even when
using 8.04. There has been some nice improvements in the code since
then.

http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500

If you do not want to have to compile the modules at each kernel change
introducing an ABI bump, I would use this, as I do with great pleasure:

http://www.youplala.net/linux/home-theater-pc#toc-automatic-drivers-comp
ilation-of-a-recent-v4l-dvb-tree

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb 
 
This email (including all attachments) is the sole property of Rio Tinto Limited and may be confidential.  If you are not the intended recipient, you must not use or forward the information contained in it.  This message may not be reproduced or otherwise republished without the written consent of the sender.  If you have received this message in error, please delete the e-mail and notify the sender.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
