Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server42.ukservers.net ([217.10.138.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@nzbaxters.com>) id 1JyY3q-0006GL-P8
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 22:03:51 +0200
Received: from server42.ukservers.net (localhost.localdomain [127.0.0.1])
	by server42.ukservers.net (Postfix smtp) with ESMTP id A2F97A711E
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 21:03:15 +0100 (BST)
Received: from sy7608 (203-97-171-185.cable.telstraclear.net [203.97.171.185])
	by server42.ukservers.net (Postfix smtp) with SMTP id A7056A7093
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 21:03:14 +0100 (BST)
Message-ID: <048c01c8bab4$8a0bae00$7501010a@ad.sytec.com>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: <linux-dvb@linuxtv.org>
Date: Wed, 21 May 2008 08:03:13 +1200
MIME-Version: 1.0
Subject: [linux-dvb] vdr-1.6.0 channel not available TT-2300-C FF card only
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


>>>>>> SetPlayMode: 0
>>>>>> frame: (0, 0)-(720, 576), zoom: (1.05, 1.01)
>>>>>> GetDevice 20 0 1 -1
>>>>>> no device found
>
>>>>> works:
>>>>> UKTV;T:674000:C0M64:C:6900:1310+1210:1410=eng:0:606:810:182:8:0
>>>>>
>>>>> doesn't work:
>>>>> Sky 
>>>>> Movies;T:674000:C0M64:C:6900:1301+8190:1401=eng,1501=enm:0:606:801:182:8:0
>
>> The problem is following the TT-2300-C card, not the cam or smartcard.
>> And it's fine on the TT-1500 Budget card.
>
>> The "NO SIGNAL" coincides with the "GetDevice" message, after only a 
>> second or 2 of video on Movies channel.
>> Any ideas?
>

Can anyone suggest what I can do here?  To me this looks like a v4l-dvb 
driver problem????


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
