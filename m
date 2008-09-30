Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.186])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0=4PPs=2I=nikocity.de=mueller_michael@srs.kundenserver.de>)
	id 1KkneQ-0005wq-OC
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 00:25:04 +0200
In-Reply-To: <05763FBF-CEC8-4C6D-9DD0-42880ABB317A@nikocity.de>
References: <20080914082131.GA12258@mueller_michael.de>
	<alpine.LRH.1.10.0809150049000.7121@pub5.ifh.de>
	<05763FBF-CEC8-4C6D-9DD0-42880ABB317A@nikocity.de>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <D3D88866-76A5-4C25-B4B7-8B7113238A84@nikocity.de>
From: =?ISO-8859-1?Q?Michael_M=FCller?= <mueller_michael@nikocity.de>
Date: Wed, 1 Oct 2008 00:26:32 +0200
To: =?ISO-8859-1?Q?Michael_M=FCller?= <mueller_michael@nikocity.de>
Cc: linux-dvb@linuxtv.org, pboettcher@dibcom.fr
Subject: Re: [linux-dvb] Elgato EyeTV Diversity patch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Patrick!

Am 15.09.2008 um 09:08 schrieb Michael M=FCller:

> Hi Patrick!
>
> Am 15.09.2008 um 00:55 schrieb Patrick Boettcher:
>
>> Hi Michael,
>>
>> On Sun, 14 Sep 2008, Michael M=FCller wrote:
>>> Simply adding a new entry beside the Hauppauge Nova-T stick using  =

>>> the
>>> new ids didn't work. Using trail and error I was able to find the
>>> right combination. I also was able to activate the remote
>>> control. Since the other devices that use stk7070pd_frontend_attach0
>>> and stk7070pd_frontend_attach1 as frontends doesn't activate the  =

>>> RC I
>>> needed to start a section for my stick. If it doesn't hurt the other
>>> devices to have a RC defined perhaps you should combine them.
>>
>> Yes, please do that.
>
> I'll do that.

Sorry for the delay but I was busy the last two weeks.

I have the patch now ready but some tests show me that the RC part  =

does not work fully as expected: After hitting a key on the remote  =

control it seems that the key is send over and over again. If I hit  =

another key it switches to this key and keeps sending this key. This  =

problem already shows in a command line window. It seems to be a  =

driver problem because if I activate the outcommented info() command  =

in the driver I get the same output over and over.

Do you have an idea what's going wrong?

If not, should I remove the RC support from the patch?

Regards

Michael
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
