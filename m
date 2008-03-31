Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out.google.com ([216.239.33.17])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dcharvey@dsl.pipex.com>) id 1JgJwc-00025e-9i
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 15:21:05 +0200
Received: from spaceape9.eur.corp.google.com (spaceape9.eur.corp.google.com
	[172.28.16.143]) by smtp-out.google.com with ESMTP id m2VDKw8W007812
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 14:20:58 +0100
Received: from gremlinstew.lon.corp.google.com
	(gremlinstew.lon.corp.google.com [172.28.69.35])
	(authenticated bits=0)
	by spaceape9.eur.corp.google.com with ESMTP id m2VDKqkj000591
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 14:20:57 +0100
Message-ID: <47F0E508.20002@dsl.pipex.com>
Date: Mon, 31 Mar 2008 14:20:08 +0100
From: David Harvey <dcharvey@dsl.pipex.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1206957601.1318.linux-dvb@linuxtv.org>
	<47F0BDE4.4060205@dsl.pipex.com> <47F0CBD2.8070209@dsl.pipex.com>
In-Reply-To: <47F0CBD2.8070209@dsl.pipex.com>
Subject: Re: [linux-dvb] Nova - T disconnects
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

Nice one Eamonn and fingers crossed!  If this is the cause of the 
resurgence in this behaviour, would it indicate the root cause as to why 
the nova cards still cause disconnects at all?  On 2.6.22 I was running 
with much greater stability but still had disconnects usually after 
upwards of a week (as opposed to in a day like with 2.6.24).

dh

David Harvey wrote:
> David Harvey wrote:
>> Just a quick update.  I installed hardy (2.6.24) onto my mythbox 
>> (epia mini itx) for testing and can confirm the same disconnect 
>> behaviour with the bundled kernel presently, have not yet tried the 
>> latest hg-src with this config.  The " hub 4-1:1.0: port 2 disabled 
>> by hub (EMI?), re-enabling..." by which I mean the facility to 
>> re-enable helps no end in requiring no reboot to reset the dvb device.
>> I have a usb nova-t and nova-td (the latter of which I haven't tried 
>> again yet).
>>
>> Will report back with results of up to date mercurial if there is any 
>> likelihood of seeing a different result?
>>
>> Cheers,
>>
>> dh
>>
> I also just received the following response to a bug report I 
> submitted through ubuntu which looks promising and relevant:
>
> I'm experiencing the same problem with a DVB-T card on hardy. The fix
> for it apparently is one-line, in one file:
>
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=commit;h=5475187c2752adcc6d789592b5f68c81c39e5a81 
>
>
> Without this patch, my tuner card (a Hauppauge Nova-T 500 dual tuner)
> disconnects multiple times a day, making Hardy Heron all but useless as
> a MythTV platform. Can we please revisit the decision to push this patch
> off to the next version?
>
> -- USB port disabled by hup (EMI? re enabling) 
> https://bugs.launchpad.net/bugs/204857 You received this bug 
> notification because you are a direct subscriber of the bug.
>
>
>



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
