Return-path: <linux-media-owner@vger.kernel.org>
Received: from www49.your-server.de ([213.133.104.49]:35504 "EHLO
	www49.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0CWJt6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 05:49:58 -0400
Received: from [78.46.5.203] (helo=sslproxy01.your-server.de)
	by www49.your-server.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <mlohse@motama.com>)
	id 1Nu0kG-0007ns-QR
	for linux-media@vger.kernel.org; Tue, 23 Mar 2010 10:49:56 +0100
Received: from [188.107.127.143] (helo=[192.168.1.33])
	by sslproxy01.your-server.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <mlohse@motama.com>)
	id 1Nu13E-0005WK-DR
	for linux-media@vger.kernel.org; Tue, 23 Mar 2010 11:09:32 +0100
Message-ID: <4BA88EBD.7060607@motama.com>
Date: Tue, 23 Mar 2010 10:49:49 +0100
From: Marco Lohse <mlohse@motama.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Problems with ngene based DVB cards (Digital Devices Cine S2
 Dual 	DVB-S2 , Mystique SaTiX S2 Dual)
References: <4BA10639.3000407@motama.com> <4BA1F9C6.3020807@motama.com>	 <829197381003180709t26f76b38y7e641b8c12a2d33d@mail.gmail.com>	 <4BA2419A.4070608@motama.com> <829197381003180812n7dfe92e7v236e50d6ab7bdc0@mail.gmail.com> <4BA88B5A.3040204@motama.com>
In-Reply-To: <4BA88B5A.3040204@motama.com>
Content-Type: multipart/mixed;
 boundary="------------020505070302020702050704"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020505070302020702050704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Marco Lohse wrote:
> Devin Heitmueller wrote:
> [..]
>> Hi Marco,
>>
>> Ok, great.  Like I said, I will see if I can reproduce it here, as
>> that will help narrow down whether it's really an issue with the ngene
>> bridge, or whether it's got something to do with that particular
>> bridge/demod/tuner combination.
>>
> 
> We made some more tests and found some additional issues that we would
> like to report.
> 

Sorry, I forgot the attachment (modified szap-s2)

> Have fun, Marco
> 
> *Problem A revisited * *****************************
> 
> It was suggested that due to a bug the dvr should never be closed (as a
> work-around)
> 
> How does this affect channel tuning times?
> 
> Test (using the latest version of the modified szap-s2)
> 
> 0) su -c "rmmod ngene && modprobe ngene one_adapter=0"
> 
> 1) Run szap-s2 using a channels.conf with "Das Erste" and "ZDF" on
> different transponders
> 
> szap-s2 -S 1 -H -c channels_DVB-S2_transponder_switch.conf -a 0 -n 1 -i
> reading channels from file 'channels_DVB-S2_transponder_switch.conf'
> 
>>>> Das Erste
> zapping to 1 'Das Erste':
> delivery DVB-S2, modulation QPSK
> sat 0, frequency 11836 MHz H, symbolrate 27500000, coderate auto,
> rolloff 0.35
> vpid 0x0065, apid 0x0066, sid 0x0068
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> Opened frontend
> Opened video demux
> Opened audio demux
> status 1f | signal  69% | snr  67% | ber 1 | unc -2 | FE_HAS_LOCK
> Delay zap_to : 0.586872
> 
>>>> ZDF
> zapping to 2 'ZDF':
> delivery DVB-S2, modulation QPSK
> sat 0, frequency 11953 MHz H, symbolrate 27500000, coderate auto,
> rolloff 0.35
> vpid 0x006e, apid 0x0078, sid 0x0082
> status 1f | signal  67% | snr  63% | ber 1 | unc -2 | FE_HAS_LOCK
> Delay zap_to : 0.580473
> 
>>>> Das Erste
> zapping to 1 'Das Erste':
> delivery DVB-S2, modulation QPSK
> sat 0, frequency 11836 MHz H, symbolrate 27500000, coderate auto,
> rolloff 0.35
> vpid 0x0065, apid 0x0066, sid 0x0068
> status 1f | signal  69% | snr  67% | ber 1 | unc -2 | FE_HAS_LOCK
> Delay zap_to : 0.553754
> 
> => Good, you will see low tuning times.
> 
> 2) in parallel to 1) - and without terminating 1) - run a second
> instance of szap-s2 that reads from the device
> 
> szap-s2 -S 1 -H -c channels_DVB-S2_transponder_switch.conf -a 1 -n 1 -r
> reading channels from file 'channels_DVB-S2_transponder_switch.conf'
> zapping to 1 'Das Erste':
> delivery DVB-S2, modulation QPSK
> sat 0, frequency 11836 MHz H, symbolrate 27500000, coderate auto,
> rolloff 0.35
> vpid 0x0065, apid 0x0066, sid 0x0068
> using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
> Opened frontend
> Opened video demux
> Opened audio demux
> ..
> 
> 3) while 2) is running, go back to 1) and tune to different transponders
> again:
> 
>>>> ZDF
> zapping to 2 'ZDF':
> delivery DVB-S2, modulation QPSK
> sat 0, frequency 11953 MHz H, symbolrate 27500000, coderate auto,
> rolloff 0.35
> vpid 0x006e, apid 0x0078, sid 0x0082
> status 1f | signal  67% | snr  63% | ber 1 | unc -2 | FE_HAS_LOCK
> Delay zap_to : 1.774598
> 
>>>> Das Erste
> zapping to 1 'Das Erste':
> delivery DVB-S2, modulation QPSK
> sat 0, frequency 11836 MHz H, symbolrate 27500000, coderate auto,
> rolloff 0.35
> vpid 0x0065, apid 0x0066, sid 0x0068
> status 1f | signal  69% | snr  67% | ber 1 | unc -2 | FE_HAS_LOCK
> Delay zap_to : 1.772805
> 
> => Not good, whenver you use both tuners you will see tuning times to
> increase from approx. 0.5 secs to 1.7 secs.
> 
> 
> *Problem B revisited * *****************************
> 
> We also found that when reading data from the dvr device immediately
> after tuning was completed (e.g. the lock was successful), then approx.
> once in 50 iterations, we still get "old" data from the device. With
> "old" I mean from the transponder previously tuned to.
> 
> This results, for example, in the wrong "old" PAT received first.
> 
> Work-around: Simple and annoying. Add a sleep(1) before starting to read
> from device.
> 
> *Remark*
> 
> Both problems can _not_ be reproduced with any other board we tested
> (Tevii, KNC, ..)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------020505070302020702050704
Content-Type: application/x-gzip;
 name="modified_szap_s2.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="modified_szap_s2.tar.gz"

H4sIAGiCqEsAA+w7a3cax5L5Kv2KDrmyQUbAgNDDCs4iQDYnCGRAdryKds7A9Ig5GWbIPPSw
o/++VdXd8wLJvrmb3P1wSSx6uh5dXVVdXdXTOO6sMv/ur/3U4HNwUMPvek1rwremHTT3qR8+
+9pB/TtNa+wfHsK/A+27mlY7bDS/Y7W/WC76REFo+Ix9t3S8RcCfxnOXy8bfIc/f/PnBdudO
ZHL2YxCajj2rLN5sp/t8273J9s3DhxXPdBUccKJFYXsbVBnaczZfgEZ3I9e+1U0ezK+uWYt9
2d7aKvQi31vxQhnbWu2oVmOhxzQNG+fvPjPDNeHpQHbXD7F78VmgdyPDYYNRmTneDPGOD5u1
MlvY9KDVDgQLwi2K8UvDy8GAPZ7kxDJnQV6q+5XPg+A2KrOh54cL1l5y354bUs56PSOQHKQw
AcU4nETStHrzW4eHB9c0fDMng1Y73m8Kbew3U9NOj4JrJYY8Pwp3F4abG6INxlRzqh0q3T81
J9TvN05pjjbIDXZq37CuHSwE34Ycbr/+xGhNrfn1qYH80Txk4Gw6umCgB/QQqFG/FC6H/Q+9
8aQ9KJS3Yvcrb20JZyEvKcs5P5a3GVB0TyeAu6Wcosy2tsiaZYb/IxYgTabtYbc97gJmxnxA
SEbJIPeG79rDTg+REyvEMqQQO3unwBbQEv0BGmpCoW3j5Ku7rOdG4JFGyFm48L3oZsGUGIwU
wTyLDYanLwMWuaHtMFKcz8PId7lZ2Wa7rO/Ofb7kbsjm0OkxbswXLLSXHIBVVPC6Zne38ZHD
0EVb0ZW2Qc22xYqCy5sWQ1iJFQP7M/esIlqjxKos9XhVuy6VSmBVIQ+gbhqLbH2yrZBeECUN
cn2y/UhK6PK5B7HGcJGU5l1mluczfm8sV+BGN/Ytd5nnMoPNveUSw4Jju5xmbzHDWS0MCjAZ
1ZUZr9xUWOESnIX7geEUQMXAZmmEqKCFESK9B33+nR1wCD53V+WFfbO4Kgd3NuBcXwsNghpI
XyZJWVRr3S9v9NpdeFqhMlGz9sm2XEerMtt1V2DzrSVfBjxEBa7IGaRCBV0JFDVfgc8Da2je
LWyHF4GavXjB7CBYGXN6JK3PV69enQib2QEpQYBolaL6ijYwqp0wm/0ojPk1WwLqq1eCnth+
D1LMjYDPlyuBZF9XXGMJqo3H2doiwWEgiXBCndLYGj09bot/snMPex+F4Di1Vou9/LX2kv3x
B/veDkz7xg7jOaZJcJy9N2Am/Rb2C1JR6EVOEXX7wkVllqQ6cpighDwv0jHaI6viYlrHKJCS
r/wyr/KU5CnmmoR+w0TQ1Z6dyf8DGcVC2CAlrmkpZsL1cfvfnfH855P+BJ+N1V5Q/0trgOfz
/4P9unaA+X+zXoMKoAF4mAQ1/pP//x0f2FmlC7C9PQj2tJdCxwqSM0jZPIc2WdgA2cB2o3vW
/XDKJnXWvujDxoebY8dbPfgQpkJW7JQYJHhHrH8DJOcVoFg5tuHasOs7qvlfS16ZPZQk8XRh
B2zleze+sYS9i1k+5yzwrPDO8PkJe/AiNocd3+emjaXILIIcyA5xH6/CEEvPtK0H5AN9kWty
IWjI/SXlRPjwdnjJ3nIX0ieHXUQzB/LIgT3nLmzmBgyNPcGCm2xGfJDiDGWYSBnYmQeMIf30
3BPGbUwEGGYK8MzqagzJsMw8H5kUjRAl95m3QroSiPvAHEjfYtLKE9NPZmky0BryXkDBRIkI
zvHOdhw24ywKuBU5ZWQByOxjf/pudDll7eEn9rE9HreH008ngBwuPIByzIuQFdrWBs4wL99w
wwcQHzmc98YdSFmn7dP+oD/9BJNgZ/3psDeZsLPRmLXZRXs87XcuB+0xu7gcX4wmvQpjE45i
UXr1jIotshKo0eShYTuBmvgnMGwA0jkmWxi3HAw855CBmZS8rR6+bjxkYjge+ChOE5ATRUKC
YjHXC8vszrcxZ/bWzYrkiWXLmB9XyuzgsMnOjSBg7VswZsdYznzbvIHmeZvV6lrjuMwuJ+2K
yPgyVbJpe/nCeb2YduylHQZfL7C5D3lvDu0hqNrePHTWuympXO/Gmmm9d+U5G1isDFBbttua
u/nBsFzI9kCJBfPEvpwy3A1DK/KMQiCiVM3bWdXyPTfkrplXmIKby/unQEa0pvwEqNbbxtOK
H8BPIJzpEMt0LBv7oyEkwc3tH8AA4LcqLPr898j2ocpKAqDpY7mAQTAOBs1KDVeOy++4/z2w
cCE0kZNYEJcsNh1f9rZ/gBaUJPTAilqrpZUUpsI7aw8mCSI9EWYtxsRayPHm5Li4TqB2cF3u
QLEDhYUFOSB6p2KAC3vYG+hn/UGPFSRqUJl7rlUgTh4gYZmkVhxOOmZJ3BYQJhFiget4d7gr
wKKG+ug1rqH/wUz/tYUq4u78QYfa/jX4mOHbn0nA14ER6q73OnhYzjwHS9jXtyvbfG3gn4D7
t7Caddv8B1VZOVE+dMf/h5JcYV2GAlxfmdxB8z1cX8EGEjkEvr7ykatlXT8r8k/wXyI2Pf70
DxUPlNHGo+G0N+x2ex/6HdB61eS3wlNNYwWbwI4Zu/uOWYjJur3zy1+eoTH5MrpPE7Qvu/3R
MwS0MJCAqszA4XylzziojOv8HjYTKvsIBv4d6oYFZDoETJ8UEgAcknyBMHe8gOuG40B9i3NH
oHYSnxuEurSTTpGEI6Ml+NGXbcaQHLYrH+uDiJ/IHrGAkj5wSPBeeW6I2CIuIujxBP10D5KT
jnSGCzUIBOtVAIHdW6KzAIo4y0gfFj0lmu3KhStkUGdIjH1hDAvu/lBGBH10dlZmBfCMAp0Z
EYKWQRiWGSC4Mfz4+DgNb19ORwq0p7FHMadvlFN57RNinvU6+nA07IGELqyfREStLoCaXkfp
tGqdYNWqgDYUtCGgjQx0X0H3BXQ/4VuXlHVBWc9S1psK2hTQZkLZkFwbgmsjzbXRVLCmgKXo
9iVsX8D207DmgYA19QOENasHCezgUMAO9EOEHVQPE9jhkYAd6kcIO6weJbCjYwE70o8RdlQ9
TgyrSZUf69gqHFe1WtbqCER7A9CIQq/wp+2eRKac5UHT0vbC7vBJmV5CQcPv2+ekaABDM6Vr
7UAA8VsAtZTWGnUBxW8BbdRTOpWMD/YV9CDhrNWPJOc6aRU51xPF1ptyYGoQGFop72lqcmxq
EAK0EgStVpfDixYNAK20A+LKPL2Y/Cwmjq3UqkX2Mey9gilK8OeRAhdG77Ok4HrQQd6CPpEF
wnTaCCWNFrSDdp41OCAotC2YF0QrgwB8R2fdc8EdWxko+FVHgQudGCysCY7wYXKqJINmypU1
TQClqaGZMvXxsTSX9FdoYis1Mnn0vxS9IO8L+fKJ2DX5NNEhmZqgTuB7b5INsAoMVhPg+qbV
9I2CyM39ybU0Hg0GEOgzazcOeSk4tgu1Sj1Z9hTzYnBTgJvZ0KbADQFuNJ+JC/F+aUM+eE9H
7yR0We6RX5noLoO/eLLMvhE/wr8tpMLNlg4RWZE6X7xg+L33Jtm+2feYFJTIiuKDZ4RrWK2W
kLkUo8FHHgES6z01nvhgH55HqmdUSeqcMacdmTv8Sf38u9STznj+YgUBsh56Osr1p/RTlonY
rkjChLqQkQuayGhfckadUmYHs3XxrVAt1gF2KTZKeskXmKk3fcDgyr2u5DK/RCdpeJwzbtDD
JjUIgf8FR1EzT63Kp+e9Sex8srtR4idebtJD1ryYvMtsPYQKHHWVgsI/SBjnIQyZf08bBcYN
R/2yFolZ+NWlrtfJCeDvv7oFAYvdkurK31zvzlXVWJBHUuRX4sAruGZf9mLsPTdazrj/h1Iz
1mmP68Ng3Rl6ccF3axtMEGJVbUWOw5AQPMYIOEwy4G5g4yRLWVZ7MdlrNJh8KyiLIlaE0smI
nBAMlSOzNpGpMu0ZOnMTHZVqzxDNRT3LgMjnhhnrVdbwWM+8RIyXOboPSllisFSBHKTKf1EU
J8ODZvMCzBJG3DVmQNTGYpGdPqzw+Csmdb085X2KEotI8kMm/DCH+i5BXUAAc2muNJgXhaso
zKF3E3RaiQGocRblmfoJVsBhp1yxfOX7Czz4NTp5nE7wYNHzzXXhHFxce7i4WJGyCzZynYcS
RGtQLEAX3CF/XPm4qGhFltAT19msvxHGo9vzxeccqp1I7kduep06D2VmqCMNPPLGE0uUzI4X
ETl/bt3trRKOhmmC1uhgnK2WIXJIT54VxdlvAAosra899YH5wboVDh2QBuWLgNzAk2RgdZYi
Uz0hNym0BamSyNtaWo7+PKFP6hymtTBfZ/UW5t6s2cIsO0fYSQgtPme1FtZAUHi0oL6F0rQF
5SjUmS2oLSHvgq8mVI8tqBihUGxBcQg1YQvqQCjxWlDWYTnXwhIOE90WZn650UYpi4n8Ebli
/gZJXwvTPMgN8bsGklwOfx6OPg5zLN4n4eEj3isA/7UDESXK9KXgwYrPbQsthCdcKvJZLHUe
I85u6O2G7UIfmBWs49jiKDA3cADLYx6Q7BM8+ZGRKWEMYM81Y654woMc1fkOOtK3jdROtNS1
A1zfwRq3aAX2jdmJc0v12gNXnCleMvGAxvJwJcIo2W0PlrtOgZW2cnN5b5llAqxs1YBdU1zq
IIxbn66ryI0VCHREgBCJO6cMMdAjOvDSBW7jwIz9yGr4yhybuKffa5ZllVh1l9k3LlmAXjYA
FFYZrVvmGxg95cFggMeB8YtyPOtVzFEkuhCB8s0iy8IjqM+QDkJhDZk7FrN4F4Iua+Bhf1HO
snv+iz7pTfXTy7Oz3lif9P8bCv+EvoT5JOSdeI1iRWfXxcIGEmYZsD2YhRLdrNjeiudewbm0
cEYn6V7bhSAN/ciqP9TVsWYGR0RyTAtvffYToY4up/p0ok/bF+gRsqPb64y6vXGGVpkLh5bN
DNxyjJtAjX9+3uv229OePpm2x1Ol0I1auuhN8Lx72huX2YuYnVKSuPhCYd2CzNQEfWGBuUYr
tcUKqNVC8aLfxQPT+53a/n3pNdsx2c4SXLQsvI/e2JRQKmV2OrmXis54wqM4jr0Bb4ZArQO5
TIJhFrBchO8GtimuWqFXGyHObu5FbngiuwQhneDGSJRJJD2wvun0yOHuTbiAzggSphuXmyIZ
BO8Jr/ZrxwfXa6BdgAEjxDjJLJ9gHuaWj5W6q/TCSt9UsuiWklVJxLQqyq70dVW7JoXWMrCl
EfymIJZFEHxv5EVhwuVpt2B/UG/nXa/zs94Zd5SbFEmHQOOtuFtUih7p4+7HcamE6124hVo8
iMYxo6E9VWRzqcWTu6OUdkVpLOVOsRtaGfdT4xBNDjkzEJ27C6YbB5b16PfS/DK44IyL5C8w
ZexXYoFJYwOheUtq8lDLkgujkL3Rh974bDD6SPHk29ioqCWwY33GE0VqXXpkIJNeAolprs0z
M1Ga6VbWn7F2xLGvtGv2Ar0IFPzjj+yoBC6A3fXrrEhQmOcYvGINOUEXNh0szOAJPf9Vix2d
rA+4R91ovHipaSe4KUDCHC3xDqbL1RhYYYYGFCm0md8tPDASehLtC9JmOfZvYp2JxateMeFE
cUKwJtLz08QVOqquU7gtihzyzl0SJYSq6kJVWk5VDXkbb03BtfhentIL7U4bFLMvrIT/5ywp
7ShFkfWuCCh2wH+f6/OlyVKb9O1MlwCIBBhoEA7/MEiBYhp1PWR3hh2KM49bD6Yn8aEgNPVl
cEPZAXqpxdHj9FvPCbHsheo/vouZGnsX/uCdY8pgJEkIptQhMUWiMGYEuYuNJNA5i+/BilWP
w531aBFP6VB+0utQC18epXZntRxSuOnlvpHhh9Fg2n4LPG+fZiRxMqEjohd+Ra1JiUWttnGA
bn/Se98BHsOuft6eQPjRO+ddiFcwz7038GfzmJvJNg1PfNBgKSn+edFOL8eTKcSdr0tDmP+8
HhLLhd9sLvTlbXqHThckDYcFRsgdB6+c4I2BlbhuDZEAige6qiNzfPnqHnJI4xa4UUVMNf8i
DFevq9W7u7sKj4AV8KvMvWWV3i+nD0DJfYtyl1dpsHhtLTNhz9GhKgvF08LW8YZ5JhtOVgD+
a8Fsv7AvX2r3HG+e32v0t3GEfy1q1+TfxzLbf6TL6RgMq7u721swM0oHoMyHMpi59gxmhEEe
C/SZHQb4m4072c/iTiLEFjN8QBdHR5BPeXiuI1ri7T094ASQAiIoCFzBf7DYIXiR7CglhDPY
9oQWgPN+Kd4YACBVACmqBllpjfqUkqCzBp31EiVw+XAiNZxCxsUtV5yuNbDASnccYTTZwgVU
ZsmoSUAYSgIVHghdiV1FsXdYXVKc94d9/VQS0EObZMwnlGnf8PBQkIsoyFHyOLmj00G8IJHr
CyABxmv+GOhUOa/Lch6eoSUDJB2qxvW68C0ow0VDVsgZJ4Noro7QdLyFhnfRUilleKuv8PdA
fvjAVvFPR76wCrkk604/QN0wwF90fNInnyDMnJe3KlHFNEIDKw4SjX5LkaU5G/feX/aGnU/l
rRQ6zXwD9vmoezloT/ujYZp56lhinWTy6fx0NNDHkHemaQJ/A25/OIToeNbrZITBw4tNuPLK
QAZ3/SJBjky+XcoQqfOKdeyL/mA0zeBSz1PMp5cQ9LD7caPh8MACkGHJSOtV0JFa7BgZVRAJ
U/UVkWO4wMAzxx9fgMtCMKCTHvIMUTTL3EhLElkZprkM1G8hDvc+9IawG7zg6R1xBjnZb6l0
vCjdAxI/9SKR0twN/fXMvfYe6Ls9iCuH3PhUI45HF73x9JPYJmHqpY3JfQ57UwHxXJEoF7W4
frPg89/05DRaLDxdRX6ovWWgx2NWXR2z0lIsYo5UAgysnfDw3wgjqLWZaMi0SjvAHhd/rAJh
wXDS2daM+xgv5p7vQ97HTX3mePPfAlllZoozCJ7emuF0qblxr93FKm16OQHFieE3HVxkUTNa
w6vK3pLHx/IBW9K9Y9cD6aPVyoPwbDgOJt34jgAFgL0nXEQBu+MYwiBZp5SRqn8s72jMgEDV
Z+Xuvx22ByDTuDd8O32HEyBFpScgevDWVP3kWV5DLAhB2xli1/865SmVkjOeocTjvK9SXg47
o/G415n2gMtg1PkZbbBu1DTfdagcRo6T8zVZ79GxCisWhH3ZTq1+D1utVM1OI9rZwUeYrGqj
+DsmNGA80aCfAG5tCQ5l/GkZEVP2hr9HwoMBy0IAsFnrfcJdyX8eGax9/k2S1vbvlaCiSXLW
ju6VpKKZk1VQl8VSelYSqUQ5+As01Lv2REfTlBLxaDWofrEGFOBXt1CKbbH2RpAi3WbueLJZ
fPVKLdw3UMbWxA/0VAxNJc3iBxrJQJsvCsa1K2N7extR1JyfZdNq/W97V7rdxq2kfwtPATOR
RSok1d3cqci5sqzEnrGjRFIyM8n48LTIlsRjiuRlk7KdxPNk829ebGrB1gu1W7nJYSe22Wig
UCgAhQ+FAmDpaHVOqvGTNOOCg348B/qQlvyN1nuLCWyj1oRSiEcrkFQwGXoQl8oUQFLIOkUj
A6SmiPOzqdO5X5LJMMmmsWHD/J1pJBQ7tKDeNB7yywkt0mV4Z+BmE1+H1Mpy2ZhxC3y293p/
91Djg9sABD8XIJD98TQaRJe/+kH7bVmyrU69hIuBfiEwYkAvD89kBg7Vv5cUfTghs1/FL2sz
6vQC/rFmVLZ5m8GOQKL6ylvLyziPWYzmBAjG82YdYo3D8aQ3RVcFgHE7UvUSeF47MsAOhlvi
EEjDT+u7oangtqN5NhiaZTZwDDnlUMBAE3oWzalTgww+Fp+qbHn7nVgbM6sqtAr1s8AQnhLj
xlt8S0YwWeqthURD2/Yk8YRGIVca2/gB/q1UePemk/BZIqJLo5JPgzYofqJ6niHAKDLDSSpf
KdGozYrYEFiFxGOlKak1WbM0vpXKKR/tstUTWjWQsjVEtMlYUeFXIOP4bDs0SI8kCXDTNQT4
tVR2fbhzCWh1v6DltI31eINW5vAHrT6o0imGjJ4mwKrt3SoOm7th0DpAj2FCAa7tO2H8Jt96
DTddCJZGrqTVzagqpeb3AC3oA0ODR6vEGMCrNpfXG+UzjF0OB9EkxyqvbI/UBu7Aq0PWsptg
NrwDs6SEHp5Zh2yObHExjkZThMypJThGumtWOVKJdPtUJTINSQ08pd+1tfmmSylZSeQvpWhB
KH4SYSz0bNBlIsiKMCNDrkDF98Vd+b64im9nzeIzl0RZ2KFE6tATtdbHW9lp+bTqbMUGBGiC
zS7yp0+BDBlCnu3InFQIAw11X6tVDilRk5jRQE7/VLIZAD+mzWJKive1jad225e4VphW+iPQ
VaMwkroiUxWfRwkepSGWEtmDT98t2rlmIk8dkC20nK+GjwgPFaoolXRPVeY6jqmsczENAQrP
JXAcYThtaSvptm09IzT0YYiJPR8XtH9+9WL/oEwOEZSGEmkF8EwdfIBWSLIVsMjUZzVCsSvB
f/2we3SEBjP0PiAQqo3pKQ4AhIUJDoiI4sA0Dq1blOIkMAYV6K6M23FXdQxy0eCYTpdNV75e
tnJi28lFZvW/0Md9qOMNdJ9j96kKpkCPFMiXJoA41hoerszOSkIBTs9K4eD4Jc7gk/XgJLjQ
CDUhu0wqmz8bi5IT2+xHXpdLmZAUZMYJRmoGYMCU46Gm4NrwtJjZCaY+2RGKp47rUK83dC0i
IJPZnlbalkyX6eV8F1kdrN4v9HtuQ8+q6YySzqjolILWZd3D4AEZnVTp1GiMrsnwl6kWneDF
RH5/cMz76fKSfPr74/mIBper0byWgRFbNAo/qgm+7Mr1U2ozAHNHkxCPHwKaFZonoCnIBCeI
l1zbgZ7TfUo6SE/DGTRu4wdedHclxjx53ryLDzmfs/LVV9xZ1lRmIAV16tGacr7gJXftb05H
qYyKMXox4eFVpkU/4egwwk/JsUHpNeKMnWeSru9j7amuVI6JaHW/Xqe3k0z9fBLZXxn3qf3D
w4PDLm6qDEegMnmTAypQIw+YsuzxlGWzGMMo7pdKNi+VO0sjuZ5FniPayTlRIejrzOcMYTx0
fzbxyCpnJvUYSgOwm5oDMTkbO29uM8rEZ7NRvsFGKIeOZTYbtbi2diODjY6YVNhqxZccsnrk
Mm0igk7oXQ5mPfYIp5ZIG8E3+6d4YpB2BDN+YBQwHE9/DRr2HQQdjWCs2Jxf4PlUmDBRCtyy
nQ5jHEOAR6MfBDUMSxgaxENthoHa16sJszA+3xbhWTgcd8UabQa3KPdJEdhGHMizWlP9hVmh
VFri18c7+TWUT2yVxzm048iHMrM0tUPfUoSXHhyzWf/3+NmzZ7Jge+0paPQYEk6NGQB+l9Ap
ZTAclxIWdG3fzXpCKSM/1BF29B25UdmgY78gwOeA8YYipdq9cygTxPoqSJzLpGPh1gqrjphf
lX4JapKFE7tzQfkVG6bXziboG4v1aGcvrvWdmeqfz1geoBk2HIBHOokUJJ5KlWFzSOdduQX0
DNCxPnGnKGFoMQ7i5BpIua9BDdhY1OZwpFIpdBYgYv0TNC5GyjqPQf9gt0lkhjoNlzIG+PKU
Ok+h6xjtn1AUIkPSij+O5+GHHsjWREkotVQDWfdqC7kek0pFfmByQPS2k3w5RgwrQiiNc2ib
VYWKBBbRy5ZP52wPB8LeQ90ohwtdyuJSSZSWll1N+HSzVQrINtv70FbNg1OCIDZVmUm4PBOW
Rch2CsChqD7qDoVbjzb2NroGvOM6vl0ys7WeBhKqBE9Jpae29Kseoya7NyBCWnIZGbNworh9
qbgFXawOfMA3Lhchspw0rza61tmdzUXXMgVqqpw5VGEJT6/vwNMbR+qOc8ZthO+Or5nt9Xet
hWWE0vz/wvzzy4FTGO2pcZuSmBWc5Lbmu5Yhl0q6AIeJSvNvVGlHTjmV38VtiqnwUXIX+V0L
mUckze/Ptyqj2iTXtQOeq2rW7JGW6PaiNtRx9nxu6cUU19U0v7F1QUhqFXozB0sY5ZfbCdxA
cq4x0TPi1wHGDcbafDMt0oQ4O9nvp4WVv9tn0vHxbDllNUe+XwaXbKpayrwijdGIhorPW4nu
l7UDnVS2G9sbVl5TNVYl0dNUtV6MoSx3CtURH1M6VnVzqvplXlu23cxp2vBXeDNJhFoSYa4k
UhMV53DZ60SUK6O1K9j5TGQ/3a/BXi1EhERsgUKkqoXqTvlKCWxoNmV6H9ZhZlooq6lmxgtG
s2qAv3t0QK76RRBjcWYmw/WYsrNRjFyWc+soLeSXsKQNK22v3YbpKwf5fOad/BWeTrFvLJvh
XK4vytIcMgZvdG79eh+lpI8Lozg8odSTXzMflt/gKCO7CMxwTux03KXy0UDP1iYMCberyjzc
mS8Mk9ldalKPE6oaqSMVSPfxxjme+5uX2PwmqRtUkzIT3K6oS7BRfmk1w1Tvt2RX9dJcZtVG
QOBROSVl/AvK2mzkNhE1NpU1CMm1miirvXEJUqYlSqO77LI1o1xjf8aeYbSUmsBrXBDNGQ0k
N7amLCTCqjZERhmrAX9mz0vc4E5GnvVF1/o08DwSZ+Zob+F6Z1hEK3N2sr7E2oOFu4G1J8/Y
k9KyaduPVKjTdTZOJFGGqpx5e4ZXYzmZzAEOLrSPRM7aSw4jWRuUSFdZxp8YF/fESTjo0Zkf
atPp1FpQp7PR+MTsOh1uG0+m7Mn1xjS42Z8aljm9W1hpSmtOHgEliDk6NUu2GW3CyUipMpJf
64MantH5BFefuPD+PJpFbpJh3NVWKV68oLsRnuzw+e9q+ZkvOdBGxCz7BW1nofPOdQHU+fl9
RQXP+Ini/jYdtb4t8YT1lOnMISilHmvwXHUDqdaGDNTIlKV2Cl9AhZLHdzg76+ujeeD35a9v
qbZcq/b5BD3NuHKwgWEb/zUAtfLD7vHL3pvd/3yrLK2JFqqkn7DgJm1ruZZzq4HzzOeY0qo7
fmM3Cv55qWIoPSbtzmVWaE7AZDrH0Ws6d8KSesz54I5OTnASYWp/dWuFX9thE2vSEO+Ggh5d
c9+VStVBK/fAf2n3QK3EIOam6fIE3ZVBsMjtC8QEP4rc17CX4ZDV/bH7prvXPei+fPHz+T9n
03E37J52B92jbr876n4YnuwCuLeHf1k7IpBSS35kX/iG7Av8+5x+uzYEq5upd3tvzZTF2BwS
Fsi0waNSgewg6ZV2xhSpN9eSuoHVLEXzF6eUB9fSv9KWlaJ8dC21K0xGKVonTMsoGz8v0j85
Ulpb5sbdVRa+nKNyvbz4P3L8ZWfv6smgLlpiDpsiFTOpvCN+b0NmxmRYNeeWcazKmFlZugn5
kBPb8eE2iU85sTOe3Cb1lFPbsSa3dANVfjVK3SaDvhIMKxGmDunH/enHoh6Iy1JTUotP+kMp
l+SISWr/PnWxkGnpWqElfBdzVIif9Cis2Nt20hl+4Ayzm0mWiEstLWRG4tzIL0zXdUfn3KjK
CpsZsXMjD5WULBQ2MZcWhD2iMn6HmzxWb6O9FgAP7fYFRP1uOJoAqvyN7LNZl8pbpXL8M2+S
Duse90WP0dsNhySE+S7+olrmGITs0qt8iSXcpeNLzpVLSY2Hu4ks3T/+MHRvT/hJhvKTBMdP
nBXXjAfaTXNSWfXN8MuGOUTHPMRH48ti4eXBm/1CGvSnJpNd+SVG4y2G0VxPJRKTK0Ih2tHf
dvZ0J6cr79bjrSqelri1PtxajwH+I0+O5797Xr92rgz7MIrEDuXD3sG/ky3xhrmuSSdfm2k6
LzoTShtGknPomA8ooOMFzTzd5KGngNqhU9AYsmP8h5+knHgMs0mnHcdRx3HOQYi53HqSawqx
jjWY+Ka2kHLShybtPFNCar+zm574+8Pqu3vp3cM9b3U32OM/dBnKZ87jmvt/fa/hZe//Xd3/
9ShP7t2fv7MNaW0TlfC2ftkk+5Zj7sH7l9bsNoxkuNkTggjnt2g2kYBS8PAbmBLB+K62mSDM
SaazGOnalP9y16Nu/01vKoVy/dntdPV8nudN+C5CNPY587hW/9dJ/zc8v9VsBgHd/1irr/T/
Yzx7eztn/b4QR4d7O4gF+tLcCCpe7r+gsHNx8Pzf6NfEfJ0I8fzV9y92thbxbAvvIxttnQzH
oF++kPqitWk4PyfFh3chwuxpMe2KV9/vvf7pxf5O5VW1umX+5wvbVDqiMZkNz4bjcNSF34k0
cZCMLcTx7uF3+8c7ijEhwtEIpm1FDi4JYX5iKBQEkPyXxb29Erztffv6u5IKlZWJTYXfXr96
XpKYHL9iWhBHCfUnnl0EWcBfdP+umwhFAnHQ3MCxxNrsQoc7PPVHUTjmj5VTzYAltPk/QkCr
hAjYNvuXp7/xXZfDaNDDcvagAuBL9ew3SAQ1V1LcSd2b5WY1Pjezt0268E3+cHjw/PX+m6Pq
/MNciPXqBKA61LKRhpJzCQ+o//Jrksc/Vnr/b/7MFuOe6jo9Nc/2oO08aB6o5Futpfrfwzt/
Wf/XGzANAP1fDyD6Sv8/wvPFE9Lb8358LoQ5Z4fm9lH/fCIL+tY9n099Bw2sLwt5iYpC65ge
n/Xfm8/CcTyd4GW8PQaerHwqofTwdgFfVj7kUA8ehnqA1KPxYIVXb/rk9H//0ft/PTD9vx40
uP+3Vv3/MZ579P8j7My37ab+rZTA3bNYaYKbPXn9v4d3avdmvR97/oNggWv7f6Op+n8T/kH7
X7NeW43/j/L8Wf1/hpfj+N7n1wI6o5UuyH2u7P8PBASu7/91Pf636vUm9n+/vrL/P8rz5/b/
x+r+q96/7HH7v1p6UWrg4WYB1/X/Rq3G/b/ZaDQ8xP+Nptdc9f/HeBL9n3vi8WIcSdPtcaFq
V/nseQXxIPN/Qa6K0C2vzdG/V47+zXIMHjhHmnv8RdTNDct2rzyuWf/xsM/z+O/VGzT+t+r+
av3nUZ4XYSz3Z/E86vp+u9bsnneP/E412O8GrYbndX3Phz9B2fdq277XhN/1rtcN2vjbw//E
Ly++haSdRi2T1Ic/gVf2A3/bDxpdv+ZRUs8kfR5+jGbDuH8exfLbI3n0f/87yOcCWg38CcoB
cBFA8sBw0VKkfphNjobRSTSGLBv1ukMggAbWbfg+/Am2G36jW6tBCh/o+irt4fFreRyNossh
nl0BBPx2K1OYZg3LrmTQ6FLRvJqi8GdX4j0ed1Hoc+Vxdf/363WP7X8BoIQGhvt+q7Xq/4/y
bB7hwuym3Lz5IwSeQnyENyW/xqVY6ftVT/BPGExCGVSb1aBRDbyKV21UpmEkv/Dl0ZsfJHSZ
TsVrV/y6hN5Xb0Nvl19Bm/DksNluqr9q8Nd33/+0RQQFDEvqzvm4q2/IogXg+WV1MjvbOj/b
uqyPKoPLE1kcn0V4MFMQefV6/eS0Uwvr7Lh8RndR+fUA+r77tSwHIWg++QbG/2+jExkEEpRW
o92t14BXHwCLV/O8kjgdzi7eh7NI+g0hJjOB0wlQXHGPcuyZLHrQlv1ar+F7Ua01CFuNTlRB
Ol7Nb2+hU2eCkCDXVHTVCQfRQOKkW5C/6nQ2OYkk0cZrBTUg3/GE2PwJ3Z9vWV3/Ecl4hFel
jD6adWS6mnCEPlVzqU7toWuBFfApJu8mE0ryF9Gsv5gNw1F1OJ4vPqi7zHRFqMRbsrQt4yiS
4XwegnIfSLVYTYva8sMVy9kgk/BdJMSbCbA1vMArXcLxHC/IRnYN75ph8jyN8T5x+j6f4DVs
A3JDHY6FvuIYikWbKEv2wl5yxwrjIeA9cvc9G47PqiBdGEagyBdy95YSPn4/wVu9aZcBLf2P
+5ErTqxyvOe4K0RYoqsikQNqNwk365No/j6KxrJghuWCLO7GAMokjUYldAwTBRhzU+FCnJRI
BuQBZnKwN4CTA3eCLHwOxx9VAsUB0DmkszGBUbqwGu9ilsDyMNblK5uN1WpXBfrJWc6pHt5P
BNTUaTSL+FQ/jSipLlwm0M2NS4MSCme4EVqC0sC6i6vyGG9axqwjqLaP8mwyGUAtvZy8jy7R
Hfw9cnhCzJF7Me1AJTfu0SgaldVFQMzfEF38cMsItAEfMqB/2voabJsVevrbfDD2LIL+OFj0
o2+E8EoyXuCUoDC7gNao+ujTp1f22oIQfklWt5Ystcs/5BnkIcl9WohqVWhHahBErdWseW5A
q9VuNt2ATq3T6SSSdJrNthtQ91udGtIVQckVEIkCavwhDTp48zjoTSGK0CCggF158hFvp8eG
UrARyHnRXAEOYtcHAkd41ME4caQuNg3RVyft4nYevIx8NvlQhXGHihDQXedQkJ1n6qaYwG2w
UEbQrUAvPocK1e1gkGi+abHX/U7LFXvTa3bqNRMALafeaLYD+at8uX+4j/m9D20jfOtEbDUb
jU7DDWg3Ad1QdQC/r8PZGZQo0ZWwK/RDuhYdhHcCHdSI4iTCaPTJqUiidMwCJfWFTRnqCkbp
AfZA6HQgl74mg7lFdBG9vnpdWD0x0cwIUSvJffRUHZ5iAc9Dt5byKomPNYYK/DhZKIlHkcgX
OOgXVyQgzISMmp1aM0gGtIJWIolfbzXdgHqn0XBrCCaRnXpbiYYFonyIQ4m7z4asqxhbyOE8
jkancrAgBaGPrOYxkaJxMYWol+gCWig/K86aV6kDfDFbN6vJ0rvtyveqbWgOtZob0mnW4f9E
SBvAcUc3kGOTOQlugIPdgxdqB+jpoQ+4vogx/jl0M6h9lRpHFL11k1vhRF1FAQ2BK54PbmVq
u/IyBJwwH9rcbOPsSjK/YEpueJKuIqQhCvIRqrwFKJncgpctQHdbWmPCywwv+7yYjnD6KCs8
iiA3lhfMUHAFKWKIrvRw3JW7CT3S9CSPN+MJKHJoyMTOMMZuEYEkB8xaPitc3mMaanQR+yHw
MoonICk7fMTMQwA9OpwBLCnWuSOC5lLegtyr6SJp2r/cJX9w1V1BkJQQ+60jenQCF7rjzbFN
kOqIWW9wBroGeiSRnqIDlapvASO1KtLiMCVjFFB4P5m9q/AYXbDN5ISaR2+MQ3JPSR9xhW60
E6Ev3SPZKClY5MHxqtKO6iD/idpxF1GRhJbraQKz4NSAi7KlWzykRSISYS369juIDioCJ/io
u64Bd0K8mrM+B2BIhMi/XvcE7mnUfy5nOKgsRgAEKNsTrQOrkuHDYBLFXCshwKH+PBc7Aa44
Rhhe5Ft+8oF5Av+qdly6FyA5XIwNPuWcQzPu8+hONZUP1ybjJQjvvnBCG4mH4qo9iDckuCEE
HsJsSiCcs2t9uWHCN7rCHGHGFN3DDugkRYGnf3nu4V9kqaLzv14mjv8igxEe42ROYJDhYj4x
Gw8BTtQaQp0z5XnNhjlnCq0k+pwp+N0W6tqnrOLRGyE9dR9UjmrCDZLehkjdxCSytx2J7J1C
Ql0d6J/aOxFls6Mvb5TNlr670VcXIlYC+OHcMyhSR/YDpmo3262AKwSakFsVgdyAkDtWQqdR
e4BKiJxKaLVtJbSDfFm0rCxqd5GFV2/V/uKN83O0EZjvNOoEb76DOVgSSdIt4q7eXDKhkRXq
E6i8yDDgXDVCH2FaAJqOJ34ib7JOyh61j1I5Fio92FzpYZTbX6zBLNFm/rXazL+nNkMoDZOZ
nLlhGeb68iTsv1NNhxAVYlN4XWLBULcTrPQYTrpa9UanvdJjWbkEba9Beux7ZU9iaxWCRNRp
aDt3AXpCzyWMAfOJNV2RJVajdNCWBNPZoNXSkH3zMLoIZ+9uab+syOcfQeWhJVpDUMaNbKIu
JyZwg2GMU8NwhvlVJIDlHs0GeqQ5y8pI4+pdNBRozQlU8DwLPJITbZk4mSbVzB0Ikizm6htv
cJ1FZFbBOMaail2QeBJ4GdsComyZ6QWyouYlZziV6qmBoJcqH5es+hdZpl89q2f1rJ7Vs3pW
z+pZPatn9aye1bN6Vs/qufPz/5cNRLUAyAAA
--------------020505070302020702050704--
