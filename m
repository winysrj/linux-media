Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52228 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab1L0QIg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 11:08:36 -0500
Message-ID: <4EF9ED7F.7060808@iki.fi>
Date: Tue, 27 Dec 2011 18:08:31 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_Pr=E4hauser?= <cpraehaus@cosy.sbg.ac.at>
CC: linux-media@vger.kernel.org
Subject: Re: DVB-S2 multistream support
References: <4EF67721.9050102@unixsol.org> <4EF6DD91.2030800@iki.fi> <4EF6F84C.3000307@redhat.com> <CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com> <4EF7066C.4070806@redhat.com> <loom.20111227T105753-96@post.gmane.org>
In-Reply-To: <loom.20111227T105753-96@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/27/2011 12:12 PM, Christian Prähauser wrote:
>>
>> Yes, I'm meaning something like what it was described there. I think
>> that the code written by Christian were never submitted upstream.
>>
>
> Hello Mauro,
>
> Konstantin drew my attention to this discussion. Indeed, some time ago I wrote
> a base-band demux for LinuxDVB. It was part of a project to integrate support
> for second-generation IP/DVB encapsulations (GSE). The BB-demux allows to
> register filters for different ISIs and data types (raw, generic stream,
> transport stream).
>
> I realized that the repo hosted at our University is down. If there is interest,
> I can update my patches to the latest LinuxDVB version and we can put them on a
> public repo e.g. at linuxdvb.org.
>
> Kind regards,
> Christian.

I have a question which is a little bit off-topic for that thread but I 
would like to ask since I think you could have some idea.

FEC Code Rate is often given as k/n, for example FEC 1/4. But nowadays 
there is also seen 0.x like FEC 0.8.
I have feeling that this is due to new inner coding used, LDPC instead 
of traditional convolutional codes. When convolution codes were used it 
was correct to define 1/2 as basic rate and puncture rest from that. But 
as now with LDPC we have larger blocks we cannot represent so easily. 
For example DTMB uses LDPC(7488,6016) = 6016/7488 = ~0.8034 => FEC 0.8 
is used.

I am adding DTMB support for DVB API and that's why I have to think if I 
extend old k/n FECs or define new ones as FEC 0.4/0.6/0.8.

regards
Antti

-- 
http://palosaari.fi/
