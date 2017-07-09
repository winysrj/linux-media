Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55992
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751774AbdGILPE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 07:15:04 -0400
Date: Sun, 9 Jul 2017 08:14:55 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 1/2] app: kaffeine: Fix missing PCR on live streams.
Message-ID: <20170709081455.024e4c0d@vento.lan>
In-Reply-To: <20170709094351.14642-1-tvboxspy@gmail.com>
References: <20170709094351.14642-1-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malcolm,

Em Sun,  9 Jul 2017 10:43:50 +0100
Malcolm Priestley <tvboxspy@gmail.com> escreveu:

> The ISO/IEC standard 13818-1 or ITU-T Rec. H.222.0 standard allow transport
> vendors to place PCR (Program Clock Reference) on a different PID.
> 
> If the PCR is unset the value is 0x1fff, most vendors appear to set it the
> same as video pid in which case it need not be set.
> 
> The PCR PID is at an offset of 8 in pmtSection structure.

Thanks for the patches!

Patches look good, except for two things:

- we use camelCase at Kaffeine. So, the new field should be pcrPid ;)

- you didn't use dvbsi.xml. The way we usually update dvbsi.h and part of
  dvbsi.cpp is to add a field at dvbsi.xml and then run:

	$ tools/update_dvbsi.sh

  Kaffeine should be built with the optional BUILD_TOOLS feature, in order
  for it to build the tool that parses dvbsi.xml.

Anyway, I applied your patchset and added a few pathes afterwards 
adjusting it.

Regards,
Mauro

> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  src/dvb/dvbliveview.cpp | 8 ++++++++
>  src/dvb/dvbsi.h         | 5 +++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/src/dvb/dvbliveview.cpp b/src/dvb/dvbliveview.cpp
> index cfad892..3e92fa6 100644
> --- a/src/dvb/dvbliveview.cpp
> +++ b/src/dvb/dvbliveview.cpp
> @@ -518,6 +518,7 @@ void DvbLiveView::updatePids(bool forcePatPmtUpdate)
>  	DvbPmtSection pmtSection(internal->pmtSectionData);
>  	DvbPmtParser pmtParser(pmtSection);
>  	QSet<int> newPids;
> +	int pcr_pid = pmtSection.pcr_pid();
>  	bool updatePatPmt = forcePatPmtUpdate;
>  	bool isTimeShifting = internal->timeShiftFile.isOpen();
>  
> @@ -543,6 +544,13 @@ void DvbLiveView::updatePids(bool forcePatPmtUpdate)
>  		newPids.insert(pmtParser.teletextPid);
>  	}
>  
> +	/* check PCR PID is set */
> +	if (pcr_pid != 0x1fff) {
> +		/* Check not already in list */
> +		if (!newPids.contains(pcr_pid))
> +			newPids.insert(pcr_pid);
> +	}
> +
>  	for (int i = 0; i < pids.size(); ++i) {
>  		int pid = pids.at(i);
>  
> diff --git a/src/dvb/dvbsi.h b/src/dvb/dvbsi.h
> index 4d27252..9b4bbe0 100644
> --- a/src/dvb/dvbsi.h
> +++ b/src/dvb/dvbsi.h
> @@ -1098,6 +1098,11 @@ public:
>  		return (at(3) << 8) | at(4);
>  	}
>  
> +	int pcr_pid() const
> +	{
> +		return ((at(8) & 0x1f) << 8) | at(9);
> +	}
> +
>  	DvbDescriptor descriptors() const
>  	{
>  		return DvbDescriptor(getData() + 12, descriptorsLength);



Thanks,
Mauro
