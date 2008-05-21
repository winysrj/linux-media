Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JyraO-00077x-4S
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 18:54:45 +0200
Received: by rv-out-0506.google.com with SMTP id b25so3075867rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 21 May 2008 09:54:38 -0700 (PDT)
Message-ID: <d9def9db0805210954t3a36c837g6fdbe37171330acb@mail.gmail.com>
Date: Wed, 21 May 2008 18:54:38 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Eduard Huguet" <eduardhc@gmail.com>
In-Reply-To: <617be8890805210711j726bc505jde87e32078a8d4eb@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <mailman.67.1211375422.824.linux-dvb@linuxtv.org>
	<617be8890805210711j726bc505jde87e32078a8d4eb@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] linux-dvb Digest, Vol 40, Issue 74
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

Hi,

2008/5/21 Eduard Huguet <eduardhc@gmail.com>:
>> ---------- Missatge reenviat ----------
>> From: bvidinli <bvidinli@gmail.com>
>> To: stev391@email.com, linux-dvb@linuxtv.org
>> Date: Wed, 21 May 2008 16:10:08 +0300
>> Subject: [linux-dvb] fail:Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04,
>> kernel 2.6.24-16-generic (bvidinli)
>> This problem persists, continues,
>> does anybody have suggestions ?
>>
>> i continue on my search of this problem...
>>
>> thanks.
>
>
> I'm sorry :(. I'm really not an Ubuntu expert, so I really can't help you a
> lot on this one. However, as the problem is clearly that you are mixing the
> old modules with newest ones, you should maybe consider compiling yourself a
> custrom  kernel for your machine with the DVB / V4L support removed, and
> then compile  LinuxTV drivers as described.
>
> Regards
>
>

Do you have any debug messages?
You need to compile the linuxtv code against the linux ubuntu modules
package, only problem here the linuxtv code isnt prepared to do so,
the easiest way is to cut out the saa module and integrate it into the
linux ubuntu modules source package and regenerate the lum package for
installing it.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
