Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp100.rog.mail.re2.yahoo.com ([206.190.36.78])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <jcoles0727@rogers.com>) id 1KhiZQ-0004fy-VU
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 12:23:12 +0200
Message-ID: <48D771EA.7000601@rogers.com>
Date: Mon, 22 Sep 2008 06:22:34 -0400
From: Jonathan Coles <jcoles0727@rogers.com>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <48D688BE.80008@rogers.com> <48D7009B.2000404@linuxtv.org>
In-Reply-To: <48D7009B.2000404@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] me-tv doesn't accept its own channel file
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

Steven Toth wrote:
> Jonathan Coles wrote:
>> me-tv scans ATSC channels on my HVR-950Q and creates a channels.conf 
>> file. The file has channel entries, even though the Channel Scan 
>> window reports nothing but "Failed to tune" messages. But me-tv 
>> cannot use its own file. It complains, "There's an invalid channel 
>> record in the channels.conf file." Oh, come on! Was this application 
>> tested even once?
>>
>> My file contains the following:
>>
>> CKXTDT:509028615:8VSB:65:67:2
>> CKXT:509028615:8VSB:81:83:3
>> HDTV RADIO-CANADA OTTAWA:521028615:8VSB:49:52:11
>> HDTV CBC OTTAWA:539028615:8VSB:49:52:10
>>
>> (I live in Canada. Our TV stations have until 2011 to go digital and 
>> they are moving slowly.)
>>
>> A possible problem is the strange 2-byte character following "CKXTDT" 
>> in the first line, hex 0810. Removing this line did not make the file 
>> acceptable to me-tv.
>>
>> Does anyone have experience with this glitch?
>
> Looks like you have a weird control char on the first line.
>
> Try removing this.
>
> Also use 'azap -r CKTX' to see if you get lock.
>
> - Steve
>
This is a me-tv problem. Using the same channels file, I can watch TV 
using gxine. azap returns
"video pid 0x0051, audio pid 0x0053" and then repeats the line

status 1f | signal 0078 | snr 0073 | ber 000000ff | unc 000000ff | 
FE_HAS_LOCK

Thanks for your help.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
