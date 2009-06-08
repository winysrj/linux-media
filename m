Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator2.ecc.gatech.edu ([130.207.185.172]:41838 "EHLO
	deliverator2.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755858AbZFHQU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2009 12:20:26 -0400
Message-ID: <4A2D3A40.8090307@gatech.edu>
Date: Mon, 08 Jun 2009 12:20:16 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
References: <4A2CE866.4010602@gatech.edu> <4A2D1CAA.2090500@kernellabs.com> <829197380906080717x37dd1fd8n8f37fb320ab20a37@mail.gmail.com>
In-Reply-To: <829197380906080717x37dd1fd8n8f37fb320ab20a37@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/2009 10:17 AM, Devin Heitmueller wrote:
> On Mon, Jun 8, 2009 at 10:14 AM, Steven Toth<stoth@kernellabs.com>  wrote:
>    
>>> Please let me know how I should proceed in solving this.  I would be happy
>>> to provide samples of captured video, results from new tests, etc.
>>>        
>> When you tune using azap, and you can see UNC and BER values, what is the
>> SNR value and does it move over the course of 30 seconds?
>>
>> --
>> Steven Toth - Kernel Labs
>> http://www.kernellabs.com
>>      
> Also, I believe UNC and BER display garbage when signal lock is lost,
> so do you see the "status" field change when the BER/UNC fields show
> data?
>
> Devin
>
>    
Steven, Devin,

Thanks for your replies.  The signal and SNR are usually in the range 
0x0128 - 0x0140.  They may increment or decrement on a per-second basis 
but otherwise remain steady.  The status field does not change most of 
the time when bit errors occur, but it does lose the lock from time to 
time for a second.  Here is a representative sample:

david@delldimension:~$ azap -r RTN
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 555000000 Hz
video pid 0x0051, audio pid 0x0052
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 012e | snr 012e | ber 00001b04 | unc 00001b04 | 
FE_HAS_LOCK
status 1f | signal 012c | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000269 | unc 00000269 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012c | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012c | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012c | snr 012c | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000266 | unc 00000266 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000002 | unc 00000002 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000150 | unc 00000150 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000273 | unc 00000273 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000001 | unc 00000001 | 
FE_HAS_LOCK
status 1f | signal 012c | snr 012c | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 07 | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012c | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012c | snr 012c | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012c | snr 012e | ber 00000263 | unc 00000263 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 012e | snr 012e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK

