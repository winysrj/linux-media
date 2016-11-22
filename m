Return-path: <linux-media-owner@vger.kernel.org>
From: "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
CC: Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Tue, 22 Nov 2016 22:21:12 +0000
Message-ID: <SN1PR12MB070353A173C65D77A2868A79FEB40@SN1PR12MB0703.namprd12.prod.outlook.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <CAPcyv4htu4gayz_Dpe0pnfLN4v_Kcy-fTx3B-HEfadCHvzJnhA@mail.gmail.com>
 <CAKMK7uGoXAYoazyGLbGU7svVD10WmaBtpko8BpHeNpRhST8F7g@mail.gmail.com>
 <a99fd9ea-64d8-c5d3-0b96-f96c92369601@amd.com>
 <CAKMK7uF+k5LvcPEHvtdcXQFrpKVbFxwZ32EexoU3rZ9LFhVSow@mail.gmail.com>,<CAPcyv4ind0fxek7g25MX=49rDfT5X151tb4=TYudMBmUJFZZNQ@mail.gmail.com>
In-Reply-To: <CAPcyv4ind0fxek7g25MX=49rDfT5X151tb4=TYudMBmUJFZZNQ@mail.gmail.com>
Content-Language: en-CA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>=A0I don't think we should be using numa distance to reverse engineer a
>=A0certain allocation behavior.=A0 The latency data should be truthful, bu=
t
>=A0you're right we'll need a mechanism to keep general purpose
>=A0allocations out of that range by default.=A0

Just to clarify: Do you propose/thinking to utilize NUMA API for=A0
such (VRAM) allocations?=20



    =
