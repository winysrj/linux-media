Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx1.renzel.net ([195.243.213.130] helo=nijmegen.renzel.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mws@linuxtv.org>) id 1Jygs2-0002Zc-La
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 07:28:19 +0200
Message-ID: <4833B2C9.4000903@linuxtv.org>
Date: Wed, 21 May 2008 07:27:37 +0200
From: Marcel Siegert <mws@linuxtv.org>
MIME-Version: 1.0
To: Guru <gurumurti@nkindia.com>
References: <4832D11A.5010303@linuxtv.org>
	<4f58845605bf915af9759adcc49ebf3c@nkindia.com>
In-Reply-To: <4f58845605bf915af9759adcc49ebf3c@nkindia.com>
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Subtitle
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

Guru schrieb:
re-cc-ing linuxdvb 

> Hi
> I want to insert text subtitles in a TS stream...
hi,

ah ok, so you should have a look at the 

EN 300706 - Enhanced Teletext Specification
ETR 287 - Code of Practise for enhanced Teletext

documents. they are available at etsi.org (http://pda.etsi.org/pda)
download portal.

there you can see all the information you need to create teletext data
structures. 

when you are done, you have to generate a pes stream from your data, 
and remux your ts stream. 

regards
marcel



> 
> On Tue, 20 May 2008 15:24:42 +0200, Marcel Siegert <mws@linuxtv.org> wrote:
>> Guru schrieb:
>>> Hi all,
>>> I am looking for inserting subtitle in TS stream. can any one suggest me
>> a
>>> standard  / document / source code for implementation..
>>> Thanks with regards....
>> hi,
>>
>> what kind of subtitles are you looking for?
>>
>> dvb or "normal" teletext?
>>
>> regards
>> marcel


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
